package com.linkeninc.tikget.data.ssovit

import com.google.gson.annotations.SerializedName

data class SsovitData(
    @SerializedName("desc")
    val title: String? = null,
    @SerializedName("video")
    val video: SsovitVideoData? = null
)
