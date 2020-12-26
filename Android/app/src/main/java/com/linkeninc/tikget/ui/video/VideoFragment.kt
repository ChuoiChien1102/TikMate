package com.linkeninc.tikget.ui.video

import android.Manifest
import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.PopupMenu
import androidx.core.app.ActivityCompat
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.RequestConfiguration
import com.linkeninc.tikget.BuildConfig
import com.linkeninc.tikget.R
import com.linkeninc.tikget.api.helper.PreferenceHelper
import com.linkeninc.tikget.bus.BusEvent
import com.linkeninc.tikget.bus.BusHelper
import com.linkeninc.tikget.bus.EventType
import com.linkeninc.tikget.data.VideoDownload
import com.linkeninc.tikget.extension.makeLinks
import com.linkeninc.tikget.extension.setDebouncedOnClickListener
import com.linkeninc.tikget.interactor.AppInteractor
import com.linkeninc.tikget.ui.main.MainActivity
import com.linkeninc.tikget.util.PermissionUtil
import kotlinx.android.synthetic.main.fragment_video.adView
import kotlinx.android.synthetic.main.fragment_video.ivCheckList
import kotlinx.android.synthetic.main.fragment_video.ivDelete
import kotlinx.android.synthetic.main.fragment_video.layoutNoVideo
import kotlinx.android.synthetic.main.fragment_video.rvVideos
import kotlinx.android.synthetic.main.fragment_video.tvGuide
import org.greenrobot.eventbus.Subscribe

class VideoFragment : Fragment() {

    companion object {
        private const val REQUEST_PERMISSION_IMAGE = 1998
    }

    private var appInteractor: AppInteractor? = null
    private lateinit var preferenceHelper: PreferenceHelper
    private lateinit var adapter: VideoAdapter

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_video, container, false)
    }

    override fun onStart() {
        super.onStart()
        BusHelper.subscribe(this)
    }

    override fun onDestroy() {
        BusHelper.unsubscribe(this)
        super.onDestroy()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        appInteractor = AppInteractor(context)
        preferenceHelper = PreferenceHelper(context)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        adapter = VideoAdapter(requireContext(), arrayListOf(),
            onPlayVideo = {
                (activity as? MainActivity)?.playVideo(it)
            }, onClickMore = { v, uri ->
                showPopup(v, uri)
            })
        rvVideos.layoutManager = GridLayoutManager(context, 2)
        rvVideos.adapter = adapter
        ivCheckList.setOnClickListener {
            adapter.switchMode(rvVideos)
        }
        ivDelete.setDebouncedOnClickListener {
            if (adapter.mode == VideoAdapter.MODE_SELECT) {
                showDialogConfirmDelete()
            }
        }
        tvGuide.makeLinks(
            Pair(resources.getString(R.string.link_folder_here), View.OnClickListener {
                showFolderGuide()
            })
        )
        checkPermissionGallery()
        initAds()
    }

    private fun showFolderGuide() {
        val folder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            resources.getString(R.string.folder_video)
        } else {
            resources.getString(R.string.folder_download)
        }
        val message = resources.getString(
            R.string.folder_internal,
            folder
        ) + "\n" + resources.getString(
            R.string.folder_samsung,
            folder
        ) + "\n\n" + resources.getString(
            R.string.folder_lg,
            folder
        ) + "\n\n" + resources.getString(
            R.string.folder_xiaomi,
            folder
        )
        AlertDialog.Builder(activity)
            .setTitle(R.string.guide_folder)
            .setMessage(message)
            .setPositiveButton(R.string.ok, null)
            .setIcon(R.mipmap.ic_launcher)
            .show()
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
        adView.loadAd(adRequest)
    }

    override fun onPause() {
        super.onPause()
        if (adapter.mode == VideoAdapter.MODE_SELECT) {
            adapter.switchMode(rvVideos)
        }
    }

    private fun showPopup(view: View?, uri: Uri) {
        val popup = PopupMenu(context, view)
        popup.inflate(R.menu.popup_menu)
        popup.setOnMenuItemClickListener { item: MenuItem? ->
            when (item?.itemId) {
                R.id.popup_share -> {
                    shareVideo(uri)
                }
            }
            true
        }
        popup.show()
    }

    private fun shareVideo(uri: Uri) {
        val share = Intent(Intent.ACTION_SEND)
        share.type = "video/mp4"
        share.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
        share.putExtra(Intent.EXTRA_STREAM, uri)
        share.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(share)
    }

    private fun showDialogConfirmDelete() {
        AlertDialog.Builder(activity)
            .setTitle(R.string.app_name)
            .setMessage(R.string.confirm_delete)
            .setPositiveButton(R.string.yes) { _, _ ->
                adapter.onDeleteClicked()
                checkListVideo()
            }
            .setNegativeButton(R.string.cancel, null)
            .setIcon(R.mipmap.ic_launcher)
            .show()
    }

    private fun checkPermissionGallery() {
        if (PermissionUtil.hasPermissions(Manifest.permission.READ_EXTERNAL_STORAGE)) {
            getListVideo()
        } else {
            PermissionUtil.requestPermission(
                this,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                REQUEST_PERMISSION_IMAGE
            )
        }
    }

    private fun getListVideo() {
        appInteractor?.getListDownloadedVideo()?.let {
            adapter.setData(it)
        }
        checkListVideo()
    }

    private fun checkListVideo() {
        if (adapter.videos.isNullOrEmpty()) {
            tvGuide.visibility = View.GONE
            layoutNoVideo.visibility = View.VISIBLE
        } else {
            tvGuide.visibility = View.VISIBLE
            layoutNoVideo.visibility = View.GONE
        }
    }

    @Subscribe
    fun onReceivedData(event: BusEvent) {
        when (event.eventType) {
            EventType.UPDATE_PROGRESS -> {
                val pair = event.data as? Pair<*, *>
                pair?.let {
                    adapter.updateProgress(
                        rvVideos,
                        (it.first as? String) ?: "",
                        (it.second as? Int) ?: 0
                    )
                }
            }
            EventType.ADD_DOWNLOADING -> {
                (event.data as? VideoDownload)?.let {
                    adapter.addDownloading(it)
                    rvVideos.scrollToPosition(adapter.itemCount - 1)
                }
                checkListVideo()
            }
            EventType.DOWNLOAD_SUCCESS -> {
                (event.data as? VideoDownload)?.let {
                    adapter.replaceDownloaded(it)
                }
            }
            EventType.SHOW_DATA -> {
                showData()
            }
        }
    }

    private fun showData() {
        preferenceHelper.getUser()?.let {
            adView.visibility = if (it.isVip) View.GONE else View.VISIBLE
        }
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
                            getListVideo()
                        }
                    }
                    Log.e("allowed", permission)
                } else {
                    //set to never ask again
                    Log.e("set to never ask again", permission)
                    //do something here.
                }
            }
        }
    }
}