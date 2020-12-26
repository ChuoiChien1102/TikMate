package com.linkeninc.tikget.api.dto

import com.google.gson.annotations.SerializedName

open class ErrorDTO(
        @SerializedName("message")
        val errorMessage: String?
)