package com.linkeninc.tikget.data

import com.google.gson.annotations.SerializedName

data class TiktokData(
    @SerializedName("statusCode")
    val statusCode: Int? = null,
    @SerializedName("itemInfo")
    val itemInfo: ItemInfo? = null
)
