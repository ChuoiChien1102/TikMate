package com.linkeninc.tikget

object Constant {
    const val BASE_URL = "https://www.tiktok.com/"
    const val COIN_PER_DOWNLOAD = 300
    const val TIME_OUT = 10000L //ms
    const val KEY_IS_SUB = "is_sub"
    const val FOLDER_TIK_MATE = "TikMate"
    const val LINK_PLAY_STORE = "https://play.google.com/store/apps/details?id="
    const val LINK_MY_PLAY_STORE = "https://play.google.com/store/apps/developer?id="
    const val ADS_INTERSTITIAL_ID = "ca-app-pub-6252372722104773/2499962334"
    const val ADS_REWARD_ID = "ca-app-pub-6252372722104773/6407966499"

    const val RAPID_API_KEY = "910796e769msh22bf59255e12447p16187ejsnda3a20124315"
    const val SSOVIT_RAPID_API_KEY = "2bde9d4531msh9a403d69b0cd213p1e5b6djsnd32b97f33603"

    object Subscription {
        const val ONE_WEEK = "com.linkeninc.tikget.subscription.weekly"
        const val ONE_MONTH = "com.linkeninc.tikget.subscription.monthly"
        const val THREE_MONTHS = "com.linkeninc.tikget.subscription.3month"
    }

    object Consumable {
        const val TINY_PACK = "com.linkeninc.tikget.consumable.tinypack"
        const val SMALL_PACK = "com.linkeninc.tikget.consumable.smallpack"
        const val MEDIUM_PACK = "com.linkeninc.tikget.consumable.mediumpack"
        const val LARGE_PACK = "com.linkeninc.tikget.consumable.largepack"
        const val HUGE_PACK = "com.linkeninc.tikget.consumable.hugepack"
    }

    object KeyRemote {
        const val INTERVAL_DOWNLOAD = "android_tikget_interval_download"
        const val DAILY_COIN = "android_tikget_daily_coin"
        const val WATCH_VIDEO_REWARD = "android_tikget_watch_video_reward"
        const val WATCH_INTERSTITIAL = "android_tikget_watch_interstitial"
        const val RANDOM_VIDEO_REWARD = "android_tikget_random_video_reward"
        const val CONSUMABLE_TINYPACK = "android_tikget_consumable_tinypack"
        const val CONSUMABLE_SMALLPACK = "android_tikget_consumable_smallpack"
        const val CONSUMABLE_MEDIUMPACK = "android_tikget_consumable_mediumpack"
        const val CONSUMABLE_LARGEPACK = "android_tikget_consumable_largepack"
        const val CONSUMABLE_HUGEPACK = "android_tikget_consumable_hugepack"
        const val DOWNLOAD_API_TYPE = "android_tikget_download_api_type"
    }
}