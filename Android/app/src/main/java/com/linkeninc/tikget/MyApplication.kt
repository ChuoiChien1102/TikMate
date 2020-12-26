package com.linkeninc.tikget

import android.app.Activity
import android.app.Application
import android.os.Bundle
import com.linkeninc.tikget.api.ApiEndPoint
import com.linkeninc.tikget.util.BillingHelper
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit


class MyApplication : Application() {
    companion object {
        private lateinit var apiEndPoint: ApiEndPoint
        lateinit var instance: MyApplication
            private set

        var wasInBackground: Boolean = false

        fun getApiEndPoint(): ApiEndPoint {
            return apiEndPoint
        }
    }

    override fun onCreate() {
        super.onCreate()
        BillingHelper.init(this)
        registerActivityLifecycleCallbacks(AppLifecycleTracker())
        instance = this
        val logging = HttpLoggingInterceptor()
        logging.level =
            if (BuildConfig.DEBUG) HttpLoggingInterceptor.Level.BODY else HttpLoggingInterceptor.Level.NONE
        val client = OkHttpClient.Builder()
            .addInterceptor(logging)
            .readTimeout(Constant.TIME_OUT, TimeUnit.MILLISECONDS)
            .connectTimeout(Constant.TIME_OUT, TimeUnit.MILLISECONDS)
            .build()
        apiEndPoint = Retrofit.Builder()
            .baseUrl(Constant.BASE_URL)
            .client(client)
            .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(ApiEndPoint::class.java)
    }

    inner class AppLifecycleTracker : ActivityLifecycleCallbacks {

        private var numStarted = 0

        override fun onActivityStarted(activity: Activity?) {
            if (numStarted == 0) {
                // app went to foreground
                wasInBackground = true
            }
            numStarted++
        }

        override fun onActivityStopped(activity: Activity?) {
            numStarted--
//            if (numStarted == 0) {
            // app went to background
            // do nothing
//            }
        }

        override fun onActivityPaused(p0: Activity) {
            //do nothing
        }

        override fun onActivityDestroyed(p0: Activity) {
            //do nothing
        }

        override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {
            //do nothing
        }

        override fun onActivityCreated(p0: Activity, p1: Bundle?) {
            //do nothing
        }

        override fun onActivityResumed(p0: Activity) {
            //do nothing
        }
    }
}