package com.linkeninc.tikget.ui.video

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.FileProvider
import androidx.recyclerview.widget.RecyclerView
import com.linkeninc.tikget.R
import com.linkeninc.tikget.api.helper.PreferenceHelper
import com.linkeninc.tikget.data.VideoDownload
import com.linkeninc.tikget.extension.setDebouncedOnClickListener
import com.linkeninc.tikget.extension.setImage
import com.linkeninc.tikget.task.GetFileTask
import kotlinx.android.synthetic.main.item_video.view.ivCheck
import kotlinx.android.synthetic.main.item_video.view.ivMore
import kotlinx.android.synthetic.main.item_video.view.ivVideo
import kotlinx.android.synthetic.main.item_video.view.layoutLoading
import kotlinx.android.synthetic.main.item_video.view.layoutVideo
import kotlinx.android.synthetic.main.item_video.view.progress
import kotlinx.android.synthetic.main.item_video.view.tvProgress
import kotlinx.android.synthetic.main.item_video.view.tvTitle

class VideoAdapter(
    private val context: Context,
    val videos: ArrayList<CheckedVideo>,
    private val onPlayVideo: (uri: Uri) -> Unit,
    private val onClickMore: (view: View?, uri: Uri) -> Unit
) :
    RecyclerView.Adapter<VideoAdapter.VideoViewHolder>() {

    companion object {
        const val MODE_VIEW = 0
        const val MODE_SELECT = 1
    }

    private val fileTask = GetFileTask(context)
    private val preferenceHelper = PreferenceHelper(context)
    var mode = MODE_VIEW

    fun setData(videoDownloads: ArrayList<VideoDownload>) {
        videos.clear()
        videoDownloads.forEach {
            if (fileTask.isValidVideo(it.filePath)) {
                videos.add(CheckedVideo(it))
            } else {
                preferenceHelper.removeVideo(it)
            }
        }
        notifyDataSetChanged()
    }

    fun onDeleteClicked() {
        if (mode == MODE_SELECT) {
            for (i in videos.size - 1 downTo 0) {
                if (videos[i].isChecked && videos[i].downloadVideo.filePath.isNotEmpty()) {
                    preferenceHelper.removeVideo(videos[i].downloadVideo)
                    videos.removeAt(i)
                    notifyItemRemoved(i)
                }
            }
        }
    }

    fun switchMode(recyclerView: RecyclerView) {
        mode = if (mode == MODE_VIEW) {
            MODE_SELECT
        } else {
            MODE_VIEW
        }
        videos.forEachIndexed { i, video ->
            if (video.downloadVideo.filePath.isNotEmpty()) {
                val viewHolder = recyclerView.findViewHolderForAdapterPosition(i)
                video.isChecked = false
                viewHolder?.let {
                    (viewHolder as? VideoViewHolder)?.bindCheck(false)
                }
            }
        }
    }

    fun updateProgress(recyclerView: RecyclerView, fileName: String, progress: Int) {
        val index = videos.indexOfFirst { video -> video.downloadVideo.name == fileName }
        val viewHolder = recyclerView.findViewHolderForAdapterPosition(index)
        viewHolder?.let {
            (viewHolder as? VideoViewHolder)?.updateProgress(progress)
        }
    }

    fun addDownloading(videoDownload: VideoDownload) {
        videos.add(CheckedVideo(videoDownload))
        notifyItemInserted(videos.size - 1)
    }

    fun replaceDownloaded(videoDownload: VideoDownload) {
        val checkedVideo =
            videos.find { video -> video.downloadVideo.name == videoDownload.name }
        val index =
            videos.indexOfFirst { video -> video.downloadVideo.url == videoDownload.url && video.downloadVideo.filePath.isEmpty() }
        checkedVideo?.let {
            checkedVideo.downloadVideo = videoDownload
        }
        notifyItemChanged(index)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VideoViewHolder {
        return VideoViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.item_video, null)
        )
    }

    override fun getItemCount(): Int {
        return videos.size
    }

    override fun onBindViewHolder(holder: VideoViewHolder, position: Int) {
        holder.bind(videos[position])
    }

    inner class VideoViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        fun bind(video: CheckedVideo) {
            val downloadVideo = video.downloadVideo
            itemView.tvTitle.text = downloadVideo.title
            itemView.tvTitle.isSelected = true
            itemView.ivVideo.setImage(if (downloadVideo.thumbnailUrl.isEmpty()) downloadVideo.filePath else downloadVideo.thumbnailUrl)
            if (downloadVideo.filePath.isEmpty()) {
                itemView.layoutVideo.visibility = View.GONE
                itemView.layoutLoading.visibility = View.VISIBLE
                updateProgress(0)
            } else {
                itemView.layoutVideo.visibility = View.VISIBLE
                itemView.layoutLoading.visibility = View.GONE
                bindCheck(video.isChecked)
                itemView.setOnClickListener {
                    if (mode == MODE_VIEW) {
                        fileTask.getFile(downloadVideo.filePath) { file ->
                            val uri = FileProvider.getUriForFile(
                                context,
                                context.applicationContext.packageName + ".provider",
                                file
                            )
                            onPlayVideo.invoke(uri)
                        }
                    } else {
                        video.isChecked = !video.isChecked
                        bindCheck(video.isChecked)
                    }
                }
                itemView.ivMore.setDebouncedOnClickListener {
                    if (mode == MODE_VIEW) {
                        fileTask.getFile(downloadVideo.filePath) { file ->
                            val uri = FileProvider.getUriForFile(
                                context,
                                context.applicationContext.packageName + ".provider",
                                file
                            )
                            onClickMore.invoke(it, uri)
                        }
                    }
                }
            }
        }

        fun bindCheck(isChecked: Boolean) {
            if (mode == MODE_SELECT) {
                itemView.ivCheck.isSelected = isChecked
                itemView.ivCheck.visibility = View.VISIBLE
                itemView.ivMore.visibility = View.GONE
            } else {
                itemView.ivCheck.visibility = View.GONE
                itemView.ivMore.visibility = View.VISIBLE
            }
        }

        @SuppressLint("SetTextI18n")
        fun updateProgress(progress: Int) {
            itemView.progress.progress = progress.toFloat()
            itemView.tvProgress.text = "$progress%"
        }
    }

    class CheckedVideo(
        var downloadVideo: VideoDownload,
        var isChecked: Boolean = false
    )
}