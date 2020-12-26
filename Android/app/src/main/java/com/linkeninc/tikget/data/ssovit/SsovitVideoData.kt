package com.linkeninc.tikget.data.ssovit

import com.google.gson.annotations.SerializedName

data class SsovitVideoData(
    @SerializedName("cover")
    val cover: String? = null,
    @SerializedName("noWatermark")
    val downloadUrl: String? = null
)
