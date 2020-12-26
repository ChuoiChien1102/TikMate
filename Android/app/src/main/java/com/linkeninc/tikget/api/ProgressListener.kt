package com.linkeninc.tikget.api

import com.linkeninc.tikget.data.VideoDownload

interface ProgressListener {
    fun update(url: String, fileName: String, progress: Int)
    fun getLinkFailed(isSaveError: Boolean = false)
    fun startDownload(downloadVideo: VideoDownload)
    fun downloadSuccess(downloadVideo: VideoDownload)
}