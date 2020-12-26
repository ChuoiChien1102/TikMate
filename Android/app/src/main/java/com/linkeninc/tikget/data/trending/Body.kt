package com.linkeninc.tikget.data.trending

import com.google.gson.annotations.SerializedName
import com.linkeninc.tikget.data.pam.Props

data class Body(
    @SerializedName("exploreList")
    val exploreList: List<UserCard>? = null
)