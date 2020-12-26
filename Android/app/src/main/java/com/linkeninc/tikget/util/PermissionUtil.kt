package com.linkeninc.tikget.util

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.linkeninc.tikget.MyApplication

/**
 * Created on 12/6/2016.
 *
 *
 * Check, request and manage permission.
 */
object PermissionUtil {

    /**
     * check application has a permission
     *
     * @param permission The permission need to check
     */
    fun hasPermissions(permission: String): Boolean {
        return PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(
            MyApplication.instance,
            permission
        )
    }

    /**
     * Open Application in Setting for user accept permission by hand
     */
    fun openSettingPermission(activity: Activity, requestCode: Int) {
        val intent = Intent()
        intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
        val uri = Uri.fromParts("package", MyApplication.instance.packageName, null)
        intent.data = uri
        activity.startActivityForResult(intent, requestCode)
    }

    /**
     * Open Application in Setting for user accept permission by hand from fragment
     */
    fun openSettingPermission(fragment: Fragment, requestCode: Int) {
        val intent = Intent()
        intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
        val uri = Uri.fromParts("package", MyApplication.instance.packageName, null)
        intent.data = uri
        fragment.startActivityForResult(intent, requestCode)
    }

    /**
     * Request permission by system dialog
     */
    fun requestPermission(activity: Activity, permission: String, requestCode: Int) {
        ActivityCompat.requestPermissions(activity, arrayOf(permission), requestCode)
    }

    /**
     * Request permission by system dialog from fragment
     */
    fun requestPermission(fragment: Fragment, permission: String, requestCode: Int) {
        fragment.requestPermissions(arrayOf(permission), requestCode)
    }
}