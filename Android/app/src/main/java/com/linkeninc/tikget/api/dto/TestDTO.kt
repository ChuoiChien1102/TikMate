package com.linkeninc.tikget.api.dto

import com.google.gson.annotations.SerializedName

open class TestDTO(
        @SerializedName("data")
        val data: String?
)