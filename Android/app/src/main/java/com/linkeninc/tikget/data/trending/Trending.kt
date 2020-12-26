package com.linkeninc.tikget.data.trending

import com.google.gson.annotations.SerializedName

data class Trending(
    @SerializedName("body")
    val body: List<Body>? = null
)