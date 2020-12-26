package com.linkeninc.tikget.data.pam

import com.google.gson.annotations.SerializedName

data class PageProps(
    @SerializedName("itemInfo")
    val itemInfo: ItemInfo? = null
)
