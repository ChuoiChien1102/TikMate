package com.linkeninc.tikget.data

import com.google.gson.annotations.SerializedName

data class ItemStruct(
    @SerializedName("video")
    val video: Video? = null
)
