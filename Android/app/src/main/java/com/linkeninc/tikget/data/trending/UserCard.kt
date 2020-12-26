package com.linkeninc.tikget.data.trending

import com.google.gson.annotations.SerializedName

data class UserCard(
    @SerializedName("cardItem")
    val user: UserTiktok? = null
)