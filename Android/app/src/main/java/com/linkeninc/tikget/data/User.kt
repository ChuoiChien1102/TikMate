package com.linkeninc.tikget.data

import com.google.gson.annotations.SerializedName

data class User(
    @SerializedName("coin")
    var coin: Int = 0,
    @SerializedName("vip")
    var isVip: Boolean = false,
    @SerializedName("last_online")
    var lastOnline: String = ""
)