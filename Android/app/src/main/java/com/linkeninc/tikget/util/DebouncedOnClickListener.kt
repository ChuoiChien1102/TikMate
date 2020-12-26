package com.linkeninc.tikget.util

import android.os.SystemClock
import android.view.View
import java.util.WeakHashMap
import kotlin.math.abs


abstract class DebouncedOnClickListener :
    View.OnClickListener {
    private val lastClickMap: MutableMap<View, Long>

    /**
     * Implement this in your subclass instead of onClick
     * @param v The view that was clicked
     */
    abstract fun onDebouncedClick(v: View?)

    override fun onClick(clickedView: View) {
        val previousClickTimestamp = lastClickMap[clickedView]
        val currentTimestamp = SystemClock.uptimeMillis()
        if (previousClickTimestamp == null || abs(currentTimestamp - previousClickTimestamp) > 1000) {
            lastClickMap[clickedView] = currentTimestamp
            onDebouncedClick(clickedView)
        }
    }

    init {
        lastClickMap = WeakHashMap()
    }
}