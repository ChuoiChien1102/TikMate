package com.linkeninc.tikget.data.pam

import com.google.gson.annotations.SerializedName

data class VideoPam(
    @SerializedName("id")
    val id: String? = null,
    @SerializedName("cover")
    val cover: String? = null
)
