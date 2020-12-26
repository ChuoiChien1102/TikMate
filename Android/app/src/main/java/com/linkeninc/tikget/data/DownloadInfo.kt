package com.linkeninc.tikget.data

import com.google.gson.annotations.SerializedName

data class DownloadInfo(
    @SerializedName("nw_url")
    val downloadUrl: String? = "",
    @SerializedName("video_id")
    val videoId: String? = ""
)
