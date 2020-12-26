package com.linkeninc.tikget.data

import com.google.gson.annotations.SerializedName

data class VideoInfo(
    @SerializedName("title")
    val title: String = "",
    @SerializedName("thumbnail_url")
    val thumbnailUrl: String = ""
)
