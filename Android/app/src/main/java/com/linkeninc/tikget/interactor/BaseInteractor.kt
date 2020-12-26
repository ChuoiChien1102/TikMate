package com.linkeninc.tikget.interactor

import android.content.Context
import com.linkeninc.tikget.MyApplication
import com.linkeninc.tikget.api.helper.PreferenceHelper

open class BaseInteractor(context: Context) {

    protected val apiEndPoint by lazy {
        MyApplication.getApiEndPoint()
    }

    protected val preferenceHelper by lazy {
        PreferenceHelper(context)
    }
}