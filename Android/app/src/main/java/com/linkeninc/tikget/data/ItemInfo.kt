package com.linkeninc.tikget.data

import com.google.gson.annotations.SerializedName

data class ItemInfo(
    @SerializedName("itemStruct")
    val itemStruct: ItemStruct? = null,
    @SerializedName("shareMeta")
    val shareMeta: ShareMeta? = null
)
