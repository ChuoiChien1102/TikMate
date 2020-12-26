package com.linkeninc.tikget.util

import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import java.io.*

object FileMp4Util {

    private const val SIZE_BYTE_ARRAY = 4096
    private const val FOLDER_TIK_GET = "TikMate"

    @Suppress("ReturnCount")
    fun writeMp4ToDisk(
        context: Context,
        url: String,
        inputStream: InputStream?
    ): String {
        var outputStream: OutputStream? = null
        val fileName = getFileNameMp4(url)
        val path: String
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val resolver = context.contentResolver
                val contentValues = ContentValues().apply {
                    put(MediaStore.Video.Media.TITLE, fileName)
                    put(MediaStore.Video.Media.DISPLAY_NAME, fileName)
                    put(MediaStore.Video.Media.MIME_TYPE, "video/mp4")
                    put(
                        MediaStore.MediaColumns.RELATIVE_PATH,
                        Environment.DIRECTORY_MOVIES + FOLDER_TIK_GET
                    )
                }
                val uri = resolver.insert(
                    MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY),
                    contentValues
                )
                outputStream = resolver.openOutputStream(uri!!)
                path = uri.path!!
            } else {
                val uri =
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                        .toString()
                val folder = File(uri, FOLDER_TIK_GET)
                if (!folder.exists()) {
                    folder.mkdir()
                }
                val mp4File = File(folder, fileName)
                outputStream = FileOutputStream(mp4File)
                path = mp4File.absolutePath
            }

            val fileReader = ByteArray(SIZE_BYTE_ARRAY)
            while (true) {
                val read = inputStream?.read(fileReader)
                if (read == -1) {
                    break
                }
                outputStream?.write(fileReader, 0, read!!)
            }
            outputStream?.flush()
            Log.d("PATH", path)
            return path
        } catch (e: IOException) {
            e.printStackTrace()
            return ""
        } finally {
            inputStream?.close()
            outputStream?.close()
        }
    }

    private fun getFileNameMp4(url: String): String {
        val uri = Uri.parse(url)
        var name = ""
        val params = uri.queryParameterNames
        if (params.contains("video_id")) {
            name = uri.getQueryParameter("video_id") ?: System.currentTimeMillis().toString()
        }
        return "${System.currentTimeMillis()}.mp4"
    }

    @Suppress("ReturnCount")
    fun getSavedFile(): List<File> {
//        val folder = File(
//            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
//            FOLDER_TIK_GET
//        )
//        if (!folder.exists()) {
//            return arrayListOf()
//        }
//        return folder.listFiles()?.asList() ?: arrayListOf()
        return arrayListOf(File(""))
    }
}