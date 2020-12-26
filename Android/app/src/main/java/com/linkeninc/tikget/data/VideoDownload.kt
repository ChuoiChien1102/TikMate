package com.linkeninc.tikget.data

import com.google.gson.annotations.SerializedName

data class VideoDownload(
    @SerializedName("base_url")
    val baseUrl: String,
    @SerializedName("url")
    val url: String,
    @SerializedName("name")
    val name: String,
    @SerializedName("file_path")
    val filePath: String,
    @SerializedName("title")
    val title: String,
    @SerializedName("thumbnail")
    val thumbnailUrl: String
) {
    override fun equals(other: Any?): Boolean {
        return if (other is VideoDownload) {
            filePath == other.filePath
        } else false
    }

    override fun hashCode(): Int {
        return super.hashCode()
    }
}
