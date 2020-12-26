package com.linkeninc.tikget.task

import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.util.Log
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers
import java.io.File
import java.io.FileOutputStream

class GetFileTask(private val context: Context) {

    fun getFile(filePath: String, onSuccess: (File) -> Unit) {
        Single.create<File> { emit ->
            var file: File?
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                try {
                    val contentResolver = context.contentResolver
                    val inputStream =
                        contentResolver.openInputStream(Uri.parse(filePath))
                    file = File(
                        context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS),
                        "tmp.mp4"
                    )
                    FileOutputStream(file).use { output ->
                        val buffer =
                            ByteArray(4 * 1024) // or other buffer size
                        var read: Int
                        while (inputStream!!.read(buffer).also { read = it } != -1) {
                            output.write(buffer, 0, read)
                        }
                        output.flush()
                    }

                } catch (e: Exception) {
                    file = null
                }
            } else {
                file = File(filePath)
            }
            if (file != null) {
                emit.onSuccess(file)
            }
        }.subscribeOn(Schedulers.newThread())
            .observeOn(AndroidSchedulers.mainThread())
            .doOnSuccess {
                onSuccess(it)
            }.doOnError {
                Log.d("getFile", "$it")
            }.subscribe()
    }

    fun isValidVideo(filePath: String): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val contentResolver = context.contentResolver
                contentResolver.openInputStream(Uri.parse(filePath))
            } else {
                File(filePath)
            }
            true
        } catch (e: Exception) {
            false
        }
    }
}
