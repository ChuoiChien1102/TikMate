package com.linkeninc.tikget.util

import android.util.Log
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings
import com.linkeninc.tikget.R


object RemoteConfigHelper {

    private val remoteConfig = FirebaseRemoteConfig.getInstance()
    private val configSettings =
        FirebaseRemoteConfigSettings.Builder().setMinimumFetchIntervalInSeconds(60).build()

    init {
        remoteConfig.setConfigSettingsAsync(configSettings)
        remoteConfig.setDefaultsAsync(R.xml.remote_config_defaults)
    }

    fun fetch() {
        remoteConfig.fetchAndActivate().addOnSuccessListener {
            Log.d("fetchAndActivate", "addOnSuccessListener")
        }
    }

    fun getValueString(key: String): String {
        return remoteConfig.getString(key)
    }

    fun getValueInt(key: String): Int {
        return remoteConfig.getDouble(key).toInt()
    }

}