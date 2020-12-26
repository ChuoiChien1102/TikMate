package com.linkeninc.tikget.data.trending

import com.google.gson.annotations.SerializedName

data class UserTiktok(
    @SerializedName("id")
    val id: String? = null,
    @SerializedName("type")
    val type: Int? = null,
    @SerializedName("cover")
    val cover: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("subTitle")
    val subTitle: String? = null
)