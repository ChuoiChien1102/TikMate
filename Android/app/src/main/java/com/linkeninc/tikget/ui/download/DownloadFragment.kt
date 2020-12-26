package com.linkeninc.tikget.ui.download

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.content.ClipboardManager
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.fragment.app.Fragment
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.RequestConfiguration
import com.google.firebase.auth.FirebaseAuth
import com.linkeninc.tikget.BuildConfig
import com.linkeninc.tikget.Constant
import com.linkeninc.tikget.R
import com.linkeninc.tikget.api.ProgressListener
import com.linkeninc.tikget.api.helper.PreferenceHelper
import com.linkeninc.tikget.bus.BusEvent
import com.linkeninc.tikget.bus.BusHelper
import com.linkeninc.tikget.bus.EventType
import com.linkeninc.tikget.data.User
import com.linkeninc.tikget.data.VideoDownload
import com.linkeninc.tikget.extension.setDebouncedOnClickListener
import com.linkeninc.tikget.task.DownloadTask
import com.linkeninc.tikget.ui.store.StoreActivity
import com.linkeninc.tikget.util.FirebaseHelper
import com.linkeninc.tikget.util.PermissionUtil
import com.linkeninc.tikget.util.RemoteConfigHelper
import kotlinx.android.synthetic.main.fragment_download.adView
import kotlinx.android.synthetic.main.fragment_download.btnDownload
import kotlinx.android.synthetic.main.fragment_download.btnPasteLink
import kotlinx.android.synthetic.main.fragment_download.edtUrl
import kotlinx.android.synthetic.main.fragment_download.ivCoin
import kotlinx.android.synthetic.main.fragment_download.layoutProgress
import kotlinx.android.synthetic.main.fragment_download.loading
import kotlinx.android.synthetic.main.fragment_download.progressView
import kotlinx.android.synthetic.main.fragment_download.switchAuto
import kotlinx.android.synthetic.main.fragment_download.tvCoin
import kotlinx.android.synthetic.main.fragment_download.tvProgress
import org.greenrobot.eventbus.Subscribe
import kotlin.math.max

class DownloadFragment : Fragment(), ProgressListener {

    companion object {
        private const val REQUEST_PERMISSION_IMAGE = 1999
    }

    private val firebaseAuth = FirebaseAuth.getInstance()

    private lateinit var preferenceHelper: PreferenceHelper

    private var downloadTask: DownloadTask? = null

    private var isDownloading = false

    private var lastVideoDownloading: VideoDownload? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_download, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        btnDownload?.setDebouncedOnClickListener {
            if (edtUrl?.text.toString().isNotEmpty()) {
                checkPermissionGallery()
            } else {
                Toast.makeText(activity, R.string.url_empty, Toast.LENGTH_SHORT).show()
            }
        }
        btnPasteLink?.setDebouncedOnClickListener {
            pasteLink()
        }
        switchAuto?.setOnCheckedChangeListener { _, isChecked ->
            preferenceHelper.setAutoDownload(isChecked)
        }
        layoutProgress?.setOnClickListener {
            layoutProgress?.visibility = View.GONE
        }
        switchAuto?.isChecked = preferenceHelper.getAutoDownload()
        showData()
        initAds()
    }

    @SuppressLint("HardwareIds")
    private fun initAds() {
        MobileAds.initialize(activity)
        if (BuildConfig.DEBUG) {
            val androidId = Settings.Secure.getString(
                requireActivity().contentResolver,
                Settings.Secure.ANDROID_ID
            )
            val testDeviceIds = listOf(androidId)
            val configuration =
                RequestConfiguration.Builder().setTestDeviceIds(testDeviceIds).build()
            MobileAds.setRequestConfiguration(configuration)
        }
        val adRequest = AdRequest.Builder().build()
        adView?.loadAd(adRequest)
    }

    private fun pasteLink() {
        val clipBoard =
            context?.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        clipBoard.primaryClip?.let {
            if (it.itemCount > 0) {
                edtUrl?.setText(it.getItemAt(0)?.text?.trim() ?: "")
            }
        }
    }

    fun setLink(text: String) {
        edtUrl?.setText(text)
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        downloadTask = DownloadTask(context)
        preferenceHelper = PreferenceHelper(context)
    }

    private fun checkPermissionGallery() {
        if (PermissionUtil.hasPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
            downloadVideo()
        } else {
            PermissionUtil.requestPermission(
                this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                REQUEST_PERMISSION_IMAGE
            )
        }
    }

    private fun downloadVideo() {
        preferenceHelper.getUser()?.let { user ->
            if (!user.isVip && user.coin < Constant.COIN_PER_DOWNLOAD) {
                showCoinOut()
                return
            }
            if (isVideoExist()) {
                showMessage(
                    getString(R.string.error_video_exist),
                    R.string.yes,
                    DialogInterface.OnClickListener { _, _ ->
                        download(user)
                    })
                return
            }
            download(user)
        }
    }

    private fun isVideoExist(): Boolean {
        val url = edtUrl?.text.toString().trim()
        preferenceHelper.getVideos().forEach {
            if (it.baseUrl == url) {
                return true
            }
        }
        return false
    }

    private fun download(user: User) {
        if (isDownloading && !user.isVip) {
            showMessage(
                getString(R.string.error_download_in_progress),
                R.string.buy_vip,
                DialogInterface.OnClickListener { _, _ -> showStore(true) })
            return
        }
        showLoading()
        isDownloading = true
        downloadTask?.getVideoInfo(edtUrl?.text.toString().trim(), this)
        context?.let { hideKeyboardFrom(it, edtUrl) }
        edtUrl?.setText("")
    }

    private fun showMessage(
        message: String,
        resOk: Int = R.string.ok,
        listener: DialogInterface.OnClickListener? = null
    ) {
        AlertDialog.Builder(activity)
            .setTitle(R.string.app_name)
            .setMessage(message)
            .setPositiveButton(
                resOk, listener
            ).setNegativeButton(
                R.string.cancel, null
            )
            .setIcon(R.mipmap.ic_launcher)
            .show()
    }


    private fun showStore(isSub: Boolean = false) {
        val intent = Intent(context, StoreActivity::class.java)
        intent.putExtra(Constant.KEY_IS_SUB, isSub)
        startActivity(intent)
    }

    private fun showCoinOut() {
        AlertDialog.Builder(activity)
            .setTitle(R.string.app_name)
            .setMessage(R.string.not_enough_coin)
            .setPositiveButton(R.string.watch_video) { _, _ ->
                BusHelper.showAds(false)
//            }.setNegativeButton(R.string.ok) { _, _ ->
//                // Continue with delete operation
            }.setNeutralButton(R.string.buy_coin) { _, _ ->
                showStore()
            }
            .setIcon(R.mipmap.ic_launcher)
            .show()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        for (permission in permissions) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(
                    requireActivity(),
                    permission
                )
            ) {
                //denied
                Log.e("denied", permission)
            } else {
                if (ActivityCompat.checkSelfPermission(
                        requireContext(),
                        permission
                    ) == PackageManager.PERMISSION_GRANTED
                ) {
                    //allowed
                    when (requestCode) {
                        REQUEST_PERMISSION_IMAGE -> {
                            downloadVideo()
                        }
                    }
                    Log.e("allowed", permission)
                } else {
                    downloadVideo()
                    //set to never ask again
                    // Log.e("set to never ask again", permission)
                    //do something here.
                }
            }
        }
    }

    override fun onStart() {
        super.onStart()
        BusHelper.subscribe(this)
    }

    override fun onDestroy() {
        downloadTask?.cancelDownload()
        BusHelper.unsubscribe(this)
        super.onDestroy()
    }

    @Subscribe
    fun onReceivedData(event: BusEvent) {
        when (event.eventType) {
            EventType.SHOW_DATA -> {
                showData()
            }
            EventType.AUTO_DOWNLOAD -> {
                if (preferenceHelper.getAutoDownload()) {
                    pasteLink()
                    checkPermissionGallery()
                }
            }
        }
    }

    private fun showData() {
        preferenceHelper.getUser()?.let {
            tvCoin?.text = if (it.isVip) "VIP" else it.coin.toString()
            ivCoin?.setImageResource(if (it.isVip) R.drawable.ic_vip else R.drawable.ic_coin)
            adView?.visibility = if (it.isVip) View.GONE else View.VISIBLE
        }
    }

    private fun hideKeyboardFrom(context: Context, view: View) {
        val imm: InputMethodManager =
            context.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(view.windowToken, 0)
    }

    @SuppressLint("SetTextI18n")
    override fun update(url: String, fileName: String, progress: Int) {
        activity?.runOnUiThread {
            Log.d("progress", progress.toString())
            BusHelper.updateProgress(fileName, progress)
            if (fileName == lastVideoDownloading?.name) {
                progressView?.progress = progress.toFloat()
                tvProgress?.text = "$progress%"
            }
            if (progress == -1 || progress == 100) {
                isDownloading = false
            }
        }
    }

    override fun getLinkFailed(isSaveError: Boolean) {
        activity?.runOnUiThread {
            isDownloading = false
            hideLoading()
            Toast.makeText(
                activity,
                if (isSaveError) R.string.error_save_video_fail else R.string.error_get_video_fail,
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    override fun startDownload(downloadVideo: VideoDownload) {
        activity?.runOnUiThread {
            lastVideoDownloading = downloadVideo
            layoutProgress?.visibility = View.VISIBLE
            progressView?.progress = 0.0f
            tvProgress?.text = "0%"
            hideLoading()
            BusHelper.addDownloading(downloadVideo)
        }
    }

    override fun downloadSuccess(downloadVideo: VideoDownload) {
        if (downloadVideo.name == lastVideoDownloading?.name) {
            layoutProgress?.visibility = View.GONE
        }
        BusHelper.downloadSuccess(downloadVideo)
        preferenceHelper.increaseNumberDownload()
        decreaseCoin()
        val interval = RemoteConfigHelper.getValueInt(Constant.KeyRemote.INTERVAL_DOWNLOAD)
        if (preferenceHelper.getNumberDownload() % interval == 0 && preferenceHelper.getUser()?.isVip != true) {
            BusHelper.showAds(true)
        }
    }

    private fun decreaseCoin() {
        firebaseAuth.currentUser?.uid?.let {
            preferenceHelper.getUser()?.let { user ->
                if (!user.isVip) {
                    FirebaseHelper.setCoin(it, max(user.coin - Constant.COIN_PER_DOWNLOAD, 0))
                }
            }
        }
    }

    private fun showLoading() {
        loading?.playAnimation()
        loading?.visibility = View.VISIBLE
    }

    private fun hideLoading() {
        loading?.cancelAnimation()
        loading?.visibility = View.GONE
    }
}