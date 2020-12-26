package com.linkeninc.tikget.util

import android.app.Activity
import android.content.Context
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingClientStateListener
import com.android.billingclient.api.BillingFlowParams
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.Purchase
import com.android.billingclient.api.PurchasesUpdatedListener
import com.android.billingclient.api.SkuDetails
import com.android.billingclient.api.SkuDetailsParams
import com.linkeninc.tikget.Constant
import java.lang.ref.WeakReference

class BillingHelper(context: Context) : PurchasesUpdatedListener {

    companion object {
        private lateinit var instance: BillingHelper
        fun getInstance(): BillingHelper {
            return instance
        }

        fun init(context: Context) {
            instance = BillingHelper(context)
        }
    }

    private lateinit var activityReference: WeakReference<Activity>
    private var billingClient: BillingClient? = null
    private var purchaseListener: PurchaseListener? = null
    private var contextReference = WeakReference(context)

    fun setListener(purchaseListener: PurchaseListener) {
        this.purchaseListener = purchaseListener
    }

    fun connect(callback: ((Boolean) -> Unit)?) {
        contextReference.get()?.let {
            billingClient =
                BillingClient.newBuilder(it).setListener(this).enablePendingPurchases().build()
            billingClient?.startConnection(object : BillingClientStateListener {
                override fun onBillingSetupFinished(billingResult: BillingResult) {
                    callback?.invoke(billingResult.responseCode == BillingClient.BillingResponseCode.OK)
                }

                override fun onBillingServiceDisconnected() {
                    // Try to restart the connection on the next request to
                    // Google Play by calling the startConnection() method.
                }
            })
        }
    }

    private fun disconnect() {
        billingClient?.endConnection()
    }

    fun querySubscriptions(callback: SkuDetailsCallback) {
        val skuList = ArrayList<String>()
        skuList.add(Constant.Subscription.ONE_WEEK)
        skuList.add(Constant.Subscription.ONE_MONTH)
        skuList.add(Constant.Subscription.THREE_MONTHS)
        val params = SkuDetailsParams.newBuilder()
        params.setSkusList(skuList).setType(BillingClient.SkuType.SUBS)
        if (billingClient == null) {
            connect {
                querySubscriptions(callback)
            }
        } else {
            billingClient!!.querySkuDetailsAsync(params.build()) { _, skuDetailsList ->
                callback.onDone(skuDetailsList)
            }
        }
    }

    fun queryConsumable(callback: SkuDetailsCallback) {
        val skuList = ArrayList<String>()
        skuList.add(Constant.Consumable.TINY_PACK)
        skuList.add(Constant.Consumable.SMALL_PACK)
        skuList.add(Constant.Consumable.MEDIUM_PACK)
        skuList.add(Constant.Consumable.LARGE_PACK)
        skuList.add(Constant.Consumable.HUGE_PACK)
        val params = SkuDetailsParams.newBuilder()
        params.setSkusList(skuList).setType(BillingClient.SkuType.INAPP)
        if (billingClient == null) {
            connect {
                queryConsumable(callback)
            }
        } else {
            billingClient!!.querySkuDetailsAsync(params.build()) { _, skuDetailsList ->
                callback.onDone(skuDetailsList)
            }
        }
    }

    fun getOldSubscriptions(callback: (Purchase?) -> Unit) {
        if (billingClient == null) {
            connect {
                getOldSubscriptions(callback)
            }
        } else {
            val purchasesList =
                billingClient!!.queryPurchases(BillingClient.SkuType.SUBS).purchasesList
            if (purchasesList.isNullOrEmpty()) {
                disconnect()
                connect {
                    if (it) {
                        val list =
                            billingClient!!.queryPurchases(BillingClient.SkuType.SUBS).purchasesList
                        if (list.isNullOrEmpty()) {
                            callback.invoke(null)
                        } else {
                            callback.invoke(list.last())
                        }
                    } else {
                        callback.invoke(null)
                    }
                }
            } else {
                callback.invoke(purchasesList.last())
            }
        }
    }

    fun purchaseItem(activity: Activity, skuDetails: SkuDetails) {
        this.activityReference = WeakReference(activity)
        val builder = BillingFlowParams.newBuilder()
        builder.setSkuDetails(skuDetails)
        /** check upgrade or downgrade subscription */
        getOldSubscriptions {
            if (it != null) {
                builder.setOldSku(it.sku, it.purchaseToken)
            }
            startLaunching(activity, params = builder.build())
        }
    }

    private fun startLaunching(activity: Activity, params: BillingFlowParams) {
        if (billingClient == null) {
            connect {
                if (it) {
                    billingClient?.launchBillingFlow(activity, params)
                }
            }
        } else {
            billingClient!!.launchBillingFlow(activity, params)
        }
    }

    override fun onPurchasesUpdated(
        billingResult: BillingResult,
        purchases: MutableList<Purchase>?
    ) {
        if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
            purchases?.let {
                purchaseListener?.onPurchaseDone(purchases.last())
            }
        }
    }

    interface SkuDetailsCallback {
        fun onDone(skuDetails: List<SkuDetails>?)
    }

    interface PurchaseListener {
        fun onPurchaseDone(purchase: Purchase)
    }
}