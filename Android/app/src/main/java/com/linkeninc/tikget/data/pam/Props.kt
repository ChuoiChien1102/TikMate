package com.linkeninc.tikget.data.pam

import com.google.gson.annotations.SerializedName

data class Props(
    @SerializedName("pageProps")
    val pageProps: PageProps? = null
)
