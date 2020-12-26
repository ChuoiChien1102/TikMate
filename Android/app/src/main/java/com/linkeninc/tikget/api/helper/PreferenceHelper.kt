package com.linkeninc.tikget.api.helper

import android.content.Context
import android.util.Log
import com.google.gson.GsonBuilder
import com.google.gson.JsonSyntaxException
import com.linkeninc.tikget.data.User
import com.linkeninc.tikget.data.VideoDownload

class PreferenceHelper(context: Context) {

    companion object {
        private const val KEY_VIDEO = "video"
        private const val KEY_AUTO_DOWNLOAD = "auto_download"
        private const val KEY_INITIAL_BONUS = "initial_bonus"
        private const val KEY_USER = "user"
        private const val KEY_NUMBER_DOWNLOAD = "number_download"
    }

    private val preferences by lazy {
        Preferences(context)
    }

    private val gson by lazy {
        GsonBuilder().setPrettyPrinting().create()
    }

    fun saveVideo(video: VideoDownload) {
        val listVideo = getVideos()
        if (!listVideo.contains(video)) {
            listVideo.add(video)
        }
        Log.d("save Video", gson.toJson(listVideo))
        preferences[KEY_VIDEO] = gson.toJson(listVideo)
    }

    fun removeVideo(video: VideoDownload) {
        val listVideo = getVideos()
        if (listVideo.contains(video)) {
            listVideo.remove(video)
        }
        Log.d("save Video", gson.toJson(listVideo))
        preferences[KEY_VIDEO] = gson.toJson(listVideo)
    }

    fun getVideos(): ArrayList<VideoDownload> {
        val videoString: String = preferences[KEY_VIDEO, ""] ?: ""
        return try {
            val listVideo =
                ArrayList(gson.fromJson(videoString, Array<VideoDownload>::class.java).asList())
            Log.d("save Video", listVideo.toString())
            listVideo
        } catch (e: Exception) {
            arrayListOf()
        }
    }

    fun getAutoDownload(): Boolean {
        return preferences[KEY_AUTO_DOWNLOAD, false] ?: false
    }

    fun setAutoDownload(autoDownload: Boolean) {
        preferences[KEY_AUTO_DOWNLOAD] = autoDownload
    }

    fun getShowInitialBonus(): Boolean {
        return preferences[KEY_INITIAL_BONUS, true] ?: true
    }

    fun setShowInitialBonus(initialBonus: Boolean) {
        preferences[KEY_INITIAL_BONUS] = initialBonus
    }

    fun getNumberDownload(): Int {
        return preferences[KEY_NUMBER_DOWNLOAD, 0] ?: 0
    }

    fun increaseNumberDownload() {
        preferences[KEY_NUMBER_DOWNLOAD] = getNumberDownload() + 1
    }

    fun resetNumberDownload() {
        preferences[KEY_NUMBER_DOWNLOAD] = 0
    }

    fun setUser(userStr: String) {
        preferences[KEY_USER] = userStr
    }

    fun getUser(): User? {
        val userString: String? = preferences[KEY_USER]
        userString?.let {
            return try {
                gson.fromJson(it, User::class.java)
            } catch (e: JsonSyntaxException) {
                e.printStackTrace()
                null
            }
        }
        return null
    }
}