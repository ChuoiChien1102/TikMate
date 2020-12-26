package com.linkeninc.tikget.task

import android.content.ContentValues
import android.content.Context
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import com.linkeninc.tikget.Constant
import com.linkeninc.tikget.api.ProgressListener
import com.linkeninc.tikget.data.VideoDownload
import com.linkeninc.tikget.data.VideoInfo
import com.linkeninc.tikget.extension.result
import com.linkeninc.tikget.interactor.BaseInteractor
import com.linkeninc.tikget.util.RemoteConfigHelper
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers
import java.io.BufferedInputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.net.HttpURLConnection
import java.net.URL

class DownloadTask(private val context: Context) :
    BaseInteractor(context.applicationContext) {

    companion object {
        private const val SIZE_BYTE_ARRAY = 4096
        private const val TYPE_SSOVIT = 1
    }

    fun cancelDownload() {
//        call?.cancel()
    }

    fun getVideoInfo(url: String, listener: ProgressListener) {
        if (RemoteConfigHelper.getValueInt(Constant.KeyRemote.DOWNLOAD_API_TYPE) == TYPE_SSOVIT) {
            getSsovitVideoInfo(url, listener)
        } else {
            getPamVideoInfo(url, listener)
        }
    }

    private fun getSsovitVideoInfo(url: String, listener: ProgressListener) {
        apiEndPoint.getSsovitVideoInfo(path = url).result {
            doOnSuccess {
                val videoInfo = VideoInfo(it.title ?: "", it.video?.cover ?: "")
                createThreadDownload(context, url, it.video?.downloadUrl ?: "", videoInfo, listener)
            }
            doOnError {
                getPamVideoInfo(url, listener)
            }
        }
    }

    private fun getPamVideoInfo(url: String, listener: ProgressListener) {
        apiEndPoint.getVideoInfoPam(path = url).result {
            doOnSuccess {
                val itemInfo = it.data?.props?.pageProps?.itemInfo
                val videoInfo = VideoInfo(
                    itemInfo?.shareMeta?.title ?: "",
                    itemInfo?.itemStruct?.video?.cover ?: ""
                )
                val link =
                    "https://api2-16-h2.musical.ly/aweme/v1/play/?video_id=${itemInfo?.itemStruct?.video?.id}"
                createThreadDownload(context, url, link, videoInfo, listener)
            }
            doOnError {
                listener.getLinkFailed()
            }
        }
    }

    private fun createThreadDownload(
        context: Context,
        baseUrl: String,
        url: String,
        videoInfo: VideoInfo,
        listener: ProgressListener
    ) {
        Single.create<VideoDownload> { emitter ->
            if (url.isNotEmpty()) {
                val videoDownload = download(context, baseUrl, url, videoInfo, listener)
                if (videoDownload == null) {
                    listener.getLinkFailed(true)
                } else {
                    emitter.onSuccess(videoDownload)
                }
            } else {
                listener.getLinkFailed()
            }
        }.subscribeOn(Schedulers.newThread())
            .observeOn(AndroidSchedulers.mainThread())
            .doOnSuccess { video ->
                if (video == null) {
                    listener.update(url, "", -1)
                    Log.d("error", "error")
                } else {
                    preferenceHelper.saveVideo(video)
                    listener.downloadSuccess(video)
                }
            }.doOnError {
                listener.getLinkFailed()
                Log.e("getUrl", it.message ?: "")
            }.subscribe()
    }

    private fun download(
        context: Context,
        baseUrl: String,
        url: String,
        videoInfo: VideoInfo,
        listener: ProgressListener
    ): VideoDownload? {
        Log.d("url", "url $url")
        val fileName =
            /*Uri.parse(url).getQueryParameter("video_id") ?:*/ System.currentTimeMillis()
            .toString() + ".mp4"
        listener.startDownload(
            VideoDownload(
                baseUrl,
                url,
                fileName,
                "",
                videoInfo.title,
                videoInfo.thumbnailUrl
            )
        )
        //create url and connect
        var connection: HttpURLConnection?
        var input: InputStream? = null
        var outputStream: OutputStream? = null
        try {
            connection = URL(url).openConnection() as HttpURLConnection
            connection.addRequestProperty("User-Agent", "okhttp")
            connection.connectTimeout = Constant.TIME_OUT.toInt()
            connection.connect()
            val status = connection.responseCode
            var redirect = false
            if (status != HttpURLConnection.HTTP_OK) {
                if (status == HttpURLConnection.HTTP_MOVED_TEMP
                    || status == HttpURLConnection.HTTP_MOVED_PERM
                    || status == HttpURLConnection.HTTP_SEE_OTHER
                ) {
                    redirect = true
                }
            }
            if (redirect) {
                // open the new connection again
                val newUrl = connection.getHeaderField("Location")
                connection = URL(newUrl).openConnection() as HttpURLConnection
                connection.connectTimeout = Constant.TIME_OUT.toInt()
                connection.connect()
            }
            input = BufferedInputStream(connection.inputStream)
            val path: String
            val fileLength: Int = connection.contentLength
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val resolver = context.contentResolver
                val contentValues = ContentValues().apply {
                    put(MediaStore.Video.Media.TITLE, fileName)
                    put(MediaStore.Video.Media.DISPLAY_NAME, fileName)
                    put(MediaStore.Video.Media.MIME_TYPE, "video/mp4")
                    put(
                        MediaStore.MediaColumns.RELATIVE_PATH,
                        "Movies/${Constant.FOLDER_TIK_MATE}"
                    )
                }
                val uri = resolver.insert(
                    MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY),
                    contentValues
                )
                outputStream = resolver.openOutputStream(uri!!)
                path = uri.toString()
            } else {
                val uri =
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                        .toString()
                val folder = File(uri, Constant.FOLDER_TIK_MATE)
                if (!folder.exists()) {
                    folder.mkdir()
                }
                val mp4File = File(folder, fileName)
                outputStream = FileOutputStream(mp4File)
                path = mp4File.absolutePath
            }
            val data = ByteArray(SIZE_BYTE_ARRAY)
            var total: Long = 0
            var count: Int
            while (input.read(data).also { count = it } != -1) {
                total += count.toLong()

                // publishing the progress....
                outputStream?.write(data, 0, count)
                listener.update(url, fileName, (total * 100 / fileLength).toInt())
            }
            Log.d("Path", path)
            return VideoDownload(
                baseUrl,
                url,
                fileName,
                path,
                videoInfo.title,
                videoInfo.thumbnailUrl
            )
        } catch (e: IOException) {
            e.printStackTrace()
        } finally {
            // close streams
//            connection?.disconnect()
            outputStream?.flush()
            outputStream?.close()
            input?.close()
        }
        return null
    }
}