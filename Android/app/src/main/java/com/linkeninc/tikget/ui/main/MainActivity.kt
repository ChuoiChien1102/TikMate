package com.linkeninc.tikget.ui.main

import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.provider.Settings
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentStatePagerAdapter
import com.firebase.ui.auth.AuthUI
import com.firebase.ui.auth.IdpResponse
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.InterstitialAd
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.RequestConfiguration
import com.google.android.gms.ads.rewarded.RewardItem
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdCallback
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.messaging.FirebaseMessaging
import com.linkeninc.tikget.BuildConfig
import com.linkeninc.tikget.Constant
import com.linkeninc.tikget.MyApplication
import com.linkeninc.tikget.R
import com.linkeninc.tikget.api.helper.PreferenceHelper
import com.linkeninc.tikget.bus.BusEvent
import com.linkeninc.tikget.bus.BusHelper
import com.linkeninc.tikget.bus.EventType
import com.linkeninc.tikget.extension.setDebouncedOnClickListener
import com.linkeninc.tikget.ui.coin.CoinFragment
import com.linkeninc.tikget.ui.download.DownloadFragment
import com.linkeninc.tikget.ui.store.StoreActivity
import com.linkeninc.tikget.ui.tutorial.TutorialActivity
import com.linkeninc.tikget.ui.video.VideoFragment
import com.linkeninc.tikget.util.BillingHelper
import com.linkeninc.tikget.util.DateTimeUtil
import com.linkeninc.tikget.util.FirebaseHelper
import com.linkeninc.tikget.util.RemoteConfigHelper
import kotlinx.android.synthetic.main.activity_main.bottomNavigation
import kotlinx.android.synthetic.main.activity_main.drawerLayout
import kotlinx.android.synthetic.main.activity_main.ivMenu
import kotlinx.android.synthetic.main.activity_main.navDrawer
import kotlinx.android.synthetic.main.activity_main.viewPager
import org.greenrobot.eventbus.Subscribe
import java.util.Date
import kotlin.math.max

class MainActivity : AppCompatActivity() {

    companion object {
        private const val PAGE_HOME = 0
        private const val PAGE_DOWNLOAD = 1

        //        private const val PAGE_TRENDING = 2
        private const val PAGE_COIN = 2
        private const val REQUEST_LOGIN = 1991
        private const val REQUEST_PLAY_VIDEO = 1992
    }

    private var adapter: MainAdapter? = null

    private lateinit var interstitialAd: InterstitialAd
    private lateinit var rewardedAd: RewardedAd
    private val preferenceHelper = PreferenceHelper(this)
    private var isPlayVideo = false

    private val firebaseAuth = FirebaseAuth.getInstance()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        initAds()
        adapter = MainAdapter(supportFragmentManager)
        viewPager.adapter = adapter
        viewPager.offscreenPageLimit = 4
        bottomNavigation.itemIconTintList = null
        bottomNavigation.setOnNavigationItemSelectedListener {
            when (it.itemId) {
                R.id.navigation_download -> viewPager.setCurrentItem(PAGE_HOME, false)
                R.id.navigation_video -> viewPager.setCurrentItem(PAGE_DOWNLOAD, false)
//                R.id.navigation_trending -> viewPager.setCurrentItem(PAGE_TRENDING, false)
                else -> viewPager.setCurrentItem(PAGE_COIN, false)
            }
            true
        }

        ivMenu.setOnClickListener {
            drawerLayout.openDrawer(navDrawer)
        }
        FirebaseMessaging.getInstance().token.addOnSuccessListener {
            Log.d("firebase token", it)
        }
        val headerNav = navDrawer.getHeaderView(0)
        headerNav.findViewById<View>(R.id.layoutLogout).setDebouncedOnClickListener {
            drawerLayout.closeDrawer(navDrawer)
            logout()
        }
        headerNav.findViewById<View>(R.id.layoutBuyCoin).setDebouncedOnClickListener {
            drawerLayout.closeDrawer(navDrawer)
            val intent = Intent(this@MainActivity, StoreActivity::class.java)
            intent.putExtra(Constant.KEY_IS_SUB, false)
            startActivity(intent)
        }
        headerNav.findViewById<View>(R.id.layoutHowToUse).setDebouncedOnClickListener {
            drawerLayout.closeDrawer(navDrawer)
            showTutorial()
        }
        headerNav.findViewById<View>(R.id.layoutRateApp).setDebouncedOnClickListener {
            drawerLayout.closeDrawer(navDrawer)
            rateApp()
        }
        headerNav.findViewById<View>(R.id.layoutMoreApp).setDebouncedOnClickListener {
            drawerLayout.closeDrawer(navDrawer)
            moreApp()
        }
        headerNav.findViewById<View>(R.id.layoutFeedback).setDebouncedOnClickListener {
            drawerLayout.closeDrawer(navDrawer)
            sendMail()
        }
        headerNav.findViewById<View>(R.id.layoutPolicy).setDebouncedOnClickListener {
            drawerLayout.closeDrawer(navDrawer)
            showPolicy()
        }
        headerNav.findViewById<View>(R.id.layoutShare).setDebouncedOnClickListener {
            drawerLayout.closeDrawer(navDrawer)
            share()
        }
        if (preferenceHelper.getUser() == null) {
            showLogin()
        } else {
            getData()
        }
        Handler().postDelayed({
            handleIntent()
        }, 1000)
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        handleIntent()
    }

    private fun handleIntent() {
        if (intent?.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            intent?.action = null
            intent.getStringExtra(Intent.EXTRA_TEXT)?.let {
                (adapter?.getItem(0) as? DownloadFragment)?.setLink(it)
            }
        }
    }

    private fun initBilling() {
        BillingHelper.getInstance().connect {
            if (it) {
                restore()
            }
        }
    }

    private fun restore() {
        BillingHelper.getInstance().getOldSubscriptions {
            firebaseAuth.currentUser?.let { firebaseUser ->
                FirebaseHelper.setVip(firebaseUser.uid, it != null)
            }
        }
    }

    private fun rateApp() {
        val appPackageName = packageName // getPackageName() from Context or Activity object
        try {
            startActivity(
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("market://details?id=$appPackageName")
                )
            )
        } catch (e: ActivityNotFoundException) {
            startActivity(
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse(Constant.LINK_PLAY_STORE + appPackageName)
                )
            )
        }
    }

    private fun moreApp() {
        val devName = "LK+Inc."
        try {
            startActivity(
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("market://developer?id=$devName")
                )
            )
        } catch (e: ActivityNotFoundException) {
            startActivity(
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse(Constant.LINK_MY_PLAY_STORE + devName)
                )
            )
        }
    }

    private fun showTutorial() {
        startActivity(Intent(this, TutorialActivity::class.java))
    }

    private fun sendMail() {
        val intent = Intent(Intent.ACTION_SENDTO)
        intent.type = "message/rfc822"
        intent.data = Uri.parse("mailto:")
        intent.putExtra(Intent.EXTRA_EMAIL, arrayOf(getString(R.string.email_contact_us)))
        try {
            startActivity(Intent.createChooser(intent, getString(R.string.contact_us)))
        } catch (e: ActivityNotFoundException) {
            Toast.makeText(this, R.string.mail_report_no_app, Toast.LENGTH_SHORT).show()
        }
    }

    private fun share() {
        val intent = Intent(Intent.ACTION_SEND)
        intent.type = "text/plain"
        intent.putExtra(Intent.EXTRA_TEXT, Constant.LINK_PLAY_STORE + packageName)
        startActivity(Intent.createChooser(intent, "Share via"))
    }

    private fun showPolicy() {
        try {
            val intent =
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("https://sites.google.com/view/tikget/home")
                )
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun logout() {
        firebaseAuth.signOut()
        AuthUI.getInstance().signOut(this).addOnCompleteListener {
            // do something here
            showData()
            preferenceHelper.setUser("")
            showLogin()
        }
    }

    private fun checkOnline() {
        firebaseAuth.currentUser?.let { firebaseUser ->
            preferenceHelper.getUser()?.let {
                val currentDate = DateTimeUtil.convertDateToString(Date())
                if (it.lastOnline != currentDate) {
                    preferenceHelper.resetNumberDownload()
                    FirebaseHelper.setCoin(
                        firebaseUser.uid,
                        max(
                            RemoteConfigHelper.getValueInt(Constant.KeyRemote.DAILY_COIN),
                            it.coin
                        )
                    )
                    FirebaseHelper.setLastOnline(firebaseUser.uid, currentDate)
                }
            }
        }
    }


    @SuppressLint("HardwareIds")
    private fun initAds() {
        MobileAds.initialize(this)
        if (BuildConfig.DEBUG) {
            val androidId =
                Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
            val testDeviceIds = listOf(androidId)
            val configuration =
                RequestConfiguration.Builder().setTestDeviceIds(testDeviceIds).build()
            MobileAds.setRequestConfiguration(configuration)
        }

        //full screen ads
        interstitialAd = InterstitialAd(this)
        interstitialAd.adUnitId = Constant.ADS_INTERSTITIAL_ID
        interstitialAd.loadAd(AdRequest.Builder().build())

        //video reward
        rewardedAd = createAndLoadRewardedAd()
    }

    private fun createAndLoadRewardedAd(): RewardedAd {
        val rewardedAd = RewardedAd(this, Constant.ADS_REWARD_ID)
        val adLoadCallback = object : RewardedAdLoadCallback() {
            override fun onRewardedAdLoaded() {
                // Ad successfully loaded.
            }

            override fun onRewardedAdFailedToLoad(errorCode: Int) {
                // Ad failed to load.
            }
        }
        rewardedAd.loadAd(AdRequest.Builder().build(), adLoadCallback)
        return rewardedAd
    }

    private fun showAds(isAuto: Boolean) {
        if (rewardedAd.isLoaded) {
            val adCallback = object : RewardedAdCallback() {
                override fun onRewardedAdClosed() {
                    // Ad closed.
                    rewardedAd = createAndLoadRewardedAd()
                }

                override fun onUserEarnedReward(reward: RewardItem) {
                    // User earned reward.
                    val coin = if (isAuto) {
                        RemoteConfigHelper.getValueInt(Constant.KeyRemote.RANDOM_VIDEO_REWARD)
                    } else {
                        RemoteConfigHelper.getValueInt(Constant.KeyRemote.WATCH_VIDEO_REWARD)
                    }
                    increaseCoin(coin)
                    showMessage(getString(R.string.earned_coin, coin.toString()))
                }
            }
            rewardedAd.show(this, adCallback)
        } else {
            if (interstitialAd.isLoaded) {
                interstitialAd.adListener = object : AdListener() {

                    override fun onAdClosed() {
                        // Code to be executed when the interstitial ad is closed.
                        if (!isAuto) {
                            val coin =
                                RemoteConfigHelper.getValueInt(Constant.KeyRemote.WATCH_INTERSTITIAL)
                            increaseCoin(coin)
                            showMessage(getString(R.string.earned_coin, coin.toString()))
                        }
                        interstitialAd.loadAd(AdRequest.Builder().build())
                    }
                }
                interstitialAd.show()
            } else {
                showMessage(getString(R.string.error_no_ads))
                Log.d("TAG", "The interstitial wasn't loaded yet.")
            }
        }
    }

    private fun increaseCoin(coin: Int) {
        firebaseAuth.currentUser?.uid?.let {
            preferenceHelper.getUser()?.coin?.let { c ->
                FirebaseHelper.setCoin(it, (c + coin))
            }
        }
    }

    private fun showMessage(message: String) {
        AlertDialog.Builder(this)
            .setTitle(R.string.app_name)
            .setMessage(message)
            .setPositiveButton(
                R.string.ok
            ) { _, _ ->
                // Continue with delete operation
            }
            .setIcon(R.mipmap.ic_launcher)
            .show()
    }

    private fun showMessageFirstLogin(message: String) {
        AlertDialog.Builder(this)
            .setTitle(R.string.app_name)
            .setMessage(message)
            .setPositiveButton(R.string.ok, null)
            .setNegativeButton(R.string.do_not_show_again) { _, _ ->
                preferenceHelper.setShowInitialBonus(false)
                preferenceHelper.getAutoDownload()
            }
            .setIcon(R.mipmap.ic_launcher)
            .show()
    }

    private fun showLogin() {
        // Choose authentication providers
        val providers = arrayListOf(
            AuthUI.IdpConfig.PhoneBuilder().build(),
            AuthUI.IdpConfig.GoogleBuilder().build()
        )
        // Create and launch sign-in intent
        startActivityForResult(
            AuthUI.getInstance()
                .createSignInIntentBuilder()
                .setAvailableProviders(providers)
                .setTheme(R.style.LoginTheme)
                .setLogo(R.drawable.img_logo)
                .build(),
            REQUEST_LOGIN
        )
    }

    private fun getData() {
        firebaseAuth.currentUser?.let {
            FirebaseHelper.getUserData(it.uid) { userStr ->
                preferenceHelper.setUser(userStr)
                showData()
                Log.d("getUser success", preferenceHelper.getUser().toString())
                if (preferenceHelper.getUser()?.lastOnline.isNullOrEmpty()) {
                    FirebaseHelper.initUser(it.uid)
                }
                preferenceHelper.getUser()?.let { user ->
                    if (user.lastOnline.isEmpty() && preferenceHelper.getShowInitialBonus()) {
                        showMessageFirstLogin(
                            getString(
                                R.string.message_login_coin,
                                RemoteConfigHelper.getValueInt(Constant.KeyRemote.DAILY_COIN)
                                    .toString()
                            )
                        )
                    }
                }
            }
        }
        checkOnline()
        initBilling()
    }

    private fun showData() {
        BusHelper.showData()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_LOGIN) {
            val response = IdpResponse.fromResultIntent(data)

            if (resultCode == Activity.RESULT_OK) {
                // Successfully signed in
                getData()
            } else {
                if (response == null) {
                    finish()
                }
                Log.d("Login fail", response?.error.toString())
                // Sign in failed. If response is null the user canceled the
                // sign-in flow using the back button. Otherwise check
                // response.getError().getErrorCode() and handle the error.
                // ...
            }
        } else if (requestCode == REQUEST_PLAY_VIDEO) {
            Handler().postDelayed({ isPlayVideo = false }, 3000)
        }
    }

    override fun onStart() {
        super.onStart()
        BusHelper.subscribe(this)
    }

    override fun onDestroy() {
        BusHelper.unsubscribe(this)
        super.onDestroy()
    }

    override fun onResume() {
        super.onResume()
        RemoteConfigHelper.fetch()
        if (MyApplication.wasInBackground) {
            MyApplication.wasInBackground = false
            if (intent?.action != Intent.ACTION_SEND && !isPlayVideo) {
                Handler().postDelayed({
                    BusHelper.autoDownload()
                }, 1000)
            }
        }
    }

    fun playVideo(uri: Uri) {
        isPlayVideo = true
        val intent = Intent(Intent.ACTION_VIEW)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        intent.setDataAndType(uri, "video/*")
        startActivityForResult(intent, REQUEST_PLAY_VIDEO)
    }

    @Subscribe
    fun onReceivedData(event: BusEvent) {
        when (event.eventType) {
            EventType.WATCH_ADS -> {
                showAds((event.data as? Boolean) ?: true)
            }
        }
    }

    class MainAdapter(fragmentManager: FragmentManager) :
        FragmentStatePagerAdapter(fragmentManager, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT) {

        private val fragments = mutableListOf<Fragment>()

        init {
            fragments.add(DownloadFragment())
            fragments.add(VideoFragment())
//            fragments.add(TrendingFragment())
            fragments.add(CoinFragment())
        }

        override fun getItem(position: Int): Fragment = fragments[position]

        override fun getCount(): Int = fragments.count()
    }
}