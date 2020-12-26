package com.linkeninc.tikget.util

import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

object DateTimeUtil {
    private const val DEFAULT_FORMAT = "dd-MM-yyyy"

    fun convertDateToString(date: Date, format: String = DEFAULT_FORMAT): String {
        return try {
            val simpleDateFormat = SimpleDateFormat(format, Locale.getDefault())
            return simpleDateFormat.format(date)
        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
            ""
        } catch (e: ParseException) {
            e.printStackTrace()
            ""
        }
    }
}
