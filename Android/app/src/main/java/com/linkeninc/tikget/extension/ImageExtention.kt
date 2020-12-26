package com.linkeninc.tikget.extension

import android.widget.ImageView
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.linkeninc.tikget.R

fun ImageView.setImage(imgSource: Any?) {
    val requestOptions = RequestOptions()
//        .placeholder(R.mipmap.ic_launcher)
    Glide.with(this.context).load(imgSource).apply(requestOptions).into(this)
}

fun ImageView.setAvatar(
    imgSource: Any?,
    placeholder: Int = R.drawable.bg_user_place_holder,
    error: Int = R.drawable.bg_user_place_holder
) {
    imgSource?.let {
        val requestOptions = RequestOptions()
            .placeholder(placeholder)
            .error(error)
        Glide.with(this.context).load(imgSource).circleCrop().apply(requestOptions).into(this)
    }
}