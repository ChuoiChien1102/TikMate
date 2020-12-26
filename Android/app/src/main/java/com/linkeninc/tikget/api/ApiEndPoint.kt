package com.linkeninc.tikget.api

import com.linkeninc.tikget.Constant
import com.linkeninc.tikget.data.DownloadInfo
import com.linkeninc.tikget.data.TiktokData
import com.linkeninc.tikget.data.pam.PamData
import com.linkeninc.tikget.data.ssovit.SsovitData
import com.linkeninc.tikget.data.trending.Trending
import io.reactivex.Single
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Headers
import retrofit2.http.Path
import retrofit2.http.Query
import retrofit2.http.Streaming
import retrofit2.http.Url

interface ApiEndPoint {

    @Headers(
        "x-rapidapi-host: tiktok6.p.rapidapi.com",
        "x-rapidapi-key: ${Constant.RAPID_API_KEY}"
    )
    @GET
    fun getLinkDownload(
        @Url url: String = "https://tiktok6.p.rapidapi.com/video/nw",
        @Query("post_url") path: String
    ): Single<DownloadInfo>

    @Headers(
        "x-rapidapi-host: tiktok6.p.rapidapi.com",
        "x-rapidapi-key: ${Constant.RAPID_API_KEY}"
    )
    @GET
    fun getVideoInfo(
        @Url url: String = "https://tiktok6.p.rapidapi.com/post",
        @Query("video") path: String
    ): Single<TiktokData>

    @Headers(
        "x-rapidapi-host: tiktok9.p.rapidapi.com",
        "x-rapidapi-key: ${Constant.SSOVIT_RAPID_API_KEY}"
    )
    @GET
    fun getUserFeed(@Url url: String): Single<Any>

    @GET
    fun getVideoInfoPam(
        @Url url: String = "http://tiktok.pamvn.net/",
        @Query("url") path: String
    ): Single<PamData>


    @Headers(
        "x-rapidapi-host: tiktok9.p.rapidapi.com",
        "x-rapidapi-key: ${Constant.SSOVIT_RAPID_API_KEY}"
    )
    @GET
    fun getSsovitVideoInfo(
        @Url url: String = "https://tiktok9.p.rapidapi.com",
        @Query("url") path: String
    ): Single<SsovitData>

    @GET
    fun getTrending(
        @Url url: String = "https://m.tiktok.com/node/share/discover"
    ): Single<Trending>

    @Streaming
    @GET
    @Headers("User-Agent: okhttp")
    fun downloadFile(@Url fileUrl: String): Call<ResponseBody>

}