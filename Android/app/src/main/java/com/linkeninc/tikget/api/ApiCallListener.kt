package com.linkeninc.tikget.api

import com.google.gson.GsonBuilder
import com.linkeninc.tikget.api.dto.ErrorDTO
import io.reactivex.observers.DisposableSingleObserver
import okhttp3.internal.http2.StreamResetException
import retrofit2.HttpException
import java.net.ConnectException
import java.net.UnknownHostException

class ApiCallListener<T> : DisposableSingleObserver<T>() {

    private var onSuccessHandler: ((T) -> Unit)? = null
    private var onErrorHandler: ((Int) -> Unit)? = null
    private var onShowErrorHandler: ((Int, String) -> Unit)? = null
    private var onHideLoadingHandler: (() -> Unit)? = null
    private val gson by lazy {
        GsonBuilder().setPrettyPrinting().create()
    }

    fun doOnSuccess(handler: ((T) -> Unit)?) {
        onSuccessHandler = handler
    }

    fun doOnError(handler: ((Int) -> Unit)?) {
        onErrorHandler = handler
    }

    fun showError(handler: ((Int, String) -> Unit)?) {
        onShowErrorHandler = handler
    }

    fun doHideLoading(handler: (() -> Unit)?) {
        onHideLoadingHandler = handler
    }

    override fun onSuccess(t: T) {
        onSuccessHandler?.invoke(t)
        onHideLoadingHandler?.invoke()
    }

    override fun onError(e: Throwable) {
        val errorCode = getErrorCode(e)
        onErrorHandler?.invoke(errorCode)
        onShowErrorHandler?.invoke(errorCode, getErrorMessage(e))
        onHideLoadingHandler?.invoke()
    }

    private fun getErrorCode(e: Throwable): Int {
        return when (e) {
            is HttpException -> e.code()
            is ConnectException -> ErrorCode.UNKNOWN_HOST
            is UnknownHostException -> ErrorCode.UNKNOWN_HOST
            is StreamResetException -> ErrorCode.UNKNOWN_HOST
            else -> ErrorCode.OTHER
        }
    }

    private fun getErrorMessage(e: Throwable): String {
        return if (e is HttpException) {
            val message = e.response().errorBody()?.string() ?: ""
            return try {
                val errorDTO = gson.fromJson(message, ErrorDTO::class.java)
                errorDTO.errorMessage ?: ""
            } catch (e: Exception) {
                message
            }
        } else {
            e.message ?: ""
        }
    }
}