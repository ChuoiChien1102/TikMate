package com.linkeninc.tikget.bus

import com.linkeninc.tikget.data.VideoDownload
import org.greenrobot.eventbus.EventBus

object BusHelper {

    fun subscribe(subscriber: Any) {
        if (!EventBus.getDefault().isRegistered(subscriber)) {
            EventBus.getDefault().register(subscriber)
        }
    }

    fun unsubscribe(subscriber: Any) {
        EventBus.getDefault().unregister(subscriber)
    }

    fun updateProgress(fileName: String, progress: Int) {
        EventBus.getDefault().post(BusEvent(EventType.UPDATE_PROGRESS, Pair(fileName, progress)))
    }

    fun addDownloading(videoDownload: VideoDownload) {
        EventBus.getDefault().post(BusEvent(EventType.ADD_DOWNLOADING, videoDownload))
    }

    fun downloadSuccess(videoDownload: VideoDownload) {
        EventBus.getDefault().post(BusEvent(EventType.DOWNLOAD_SUCCESS, videoDownload))
    }

    fun showAds(isAuto: Boolean) {
        EventBus.getDefault().post(BusEvent(EventType.WATCH_ADS, isAuto))
    }

    fun showData() {
        EventBus.getDefault().post(BusEvent(EventType.SHOW_DATA, null))
    }

    fun autoDownload() {
        EventBus.getDefault().post(BusEvent(EventType.AUTO_DOWNLOAD, null))
    }
}
