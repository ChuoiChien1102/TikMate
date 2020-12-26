package com.linkeninc.tikget.interactor

import android.content.Context
import com.linkeninc.tikget.data.VideoDownload
import com.linkeninc.tikget.data.trending.UserTiktok
import io.reactivex.Single

class AppInteractor(context: Context) : BaseInteractor(context) {

    fun getListDownloadedVideo(): ArrayList<VideoDownload> {
        return preferenceHelper.getVideos()
    }

    fun getTrending(): Single<List<UserTiktok?>> {
        return apiEndPoint.getTrending().map {
            it.body?.get(0)?.exploreList?.map { userCard -> userCard.user }
        }
    }

    fun getUserFeed(userName: String): Single<Any> {
        return apiEndPoint.getUserFeed("https://tiktok9.p.rapidapi.com/user/$userName/feed").map {

        }
    }
}