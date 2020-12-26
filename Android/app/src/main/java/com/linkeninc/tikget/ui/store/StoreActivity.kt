package com.linkeninc.tikget.ui.store

import android.app.AlertDialog
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.android.billingclient.api.Purchase
import com.android.billingclient.api.SkuDetails
import com.google.firebase.auth.FirebaseAuth
import com.linkeninc.tikget.Constant
import com.linkeninc.tikget.R
import com.linkeninc.tikget.api.helper.PreferenceHelper
import com.linkeninc.tikget.extension.setDebouncedOnClickListener
import com.linkeninc.tikget.util.BillingHelper
import com.linkeninc.tikget.util.FirebaseHelper
import com.linkeninc.tikget.util.RemoteConfigHelper
import kotlinx.android.synthetic.main.activity_store.ivBack
import kotlinx.android.synthetic.main.activity_store.layoutVipDes
import kotlinx.android.synthetic.main.activity_store.loading
import kotlinx.android.synthetic.main.activity_store.rvItems
import kotlinx.android.synthetic.main.activity_store.tvRestore
import kotlinx.android.synthetic.main.activity_store.tvTitle

class StoreActivity : AppCompatActivity(), BillingHelper.PurchaseListener,
    StoreAdapter.StoreListener {

    private lateinit var adapter: StoreAdapter
    private var currentStoreItem: StoreItem? = null

    private val preferenceHelper = PreferenceHelper(this)
    private val firebaseAuth = FirebaseAuth.getInstance()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_store)
        initAdapter()
        getData()
        ivBack.setOnClickListener {
            finish()
        }
        tvRestore.setDebouncedOnClickListener {
            restore()
        }
    }

    private fun getData() {
        showLoading()
        BillingHelper.getInstance().setListener(this)
        val isSub = intent.getBooleanExtra(Constant.KEY_IS_SUB, false)
        if (isSub) {
            tvTitle.setText(R.string.buy_vip)
            layoutVipDes.visibility = View.VISIBLE
            tvRestore.visibility = View.VISIBLE
            BillingHelper.getInstance()
                .querySubscriptions(object : BillingHelper.SkuDetailsCallback {
                    override fun onDone(skuDetails: List<SkuDetails>?) {
                        skuDetails?.let {
                            val data = mutableListOf<StoreItem>()
                            it.sortedBy { skuDetails -> skuDetails.priceAmountMicros }
                                .forEach { sku ->
                                    data.add(StoreItem(skuDetails = sku, type = 0))
                                }
                            adapter.setData(data)
                            hideLoading()
                        }
                    }
                })
        } else {
            layoutVipDes.visibility = View.GONE
            tvRestore.visibility = View.GONE
            tvTitle.setText(R.string.buy_coin)
            BillingHelper.getInstance()
                .queryConsumable(object : BillingHelper.SkuDetailsCallback {
                    override fun onDone(skuDetails: List<SkuDetails>?) {
                        skuDetails?.let {
                            val data = mutableListOf<StoreItem>()
                            it.sortedBy { skuDetails -> skuDetails.priceAmountMicros }
                                .forEach { sku ->
                                    val keyCoin = when (sku.sku) {
                                        Constant.Consumable.TINY_PACK -> Constant.KeyRemote.CONSUMABLE_TINYPACK
                                        Constant.Consumable.SMALL_PACK -> Constant.KeyRemote.CONSUMABLE_SMALLPACK
                                        Constant.Consumable.MEDIUM_PACK -> Constant.KeyRemote.CONSUMABLE_MEDIUMPACK
                                        Constant.Consumable.LARGE_PACK -> Constant.KeyRemote.CONSUMABLE_LARGEPACK
                                        Constant.Consumable.HUGE_PACK -> Constant.KeyRemote.CONSUMABLE_HUGEPACK
                                        else -> ""
                                    }
                                    data.add(
                                        StoreItem(
                                            skuDetails = sku,
                                            coin = RemoteConfigHelper.getValueInt(keyCoin),
                                            type = 1
                                        )
                                    )
                                }
                            adapter.setData(data)
                            hideLoading()
                        }
                    }
                })
        }
    }

    private fun initAdapter() {
        adapter = StoreAdapter(mutableListOf(), this)
        rvItems.layoutManager = LinearLayoutManager(this)
        rvItems.adapter = adapter
    }

    private fun showLoading() {
        loading.playAnimation()
        loading.visibility = View.VISIBLE
    }

    private fun hideLoading() {
        loading.cancelAnimation()
        loading.visibility = View.GONE
    }

    override fun onPurchaseDone(purchase: Purchase) {
        if (purchase.sku.contains("subscription")) {
            setVip()
            finish()
        } else {
            val coin = currentStoreItem?.coin ?: 0
            increaseCoin(coin)
            showMessage(getString(R.string.message_purchased_coin, coin.toString()))
        }
    }

    override fun onClickItem(item: StoreItem) {
        currentStoreItem = item
        item.skuDetails?.let {
            BillingHelper.getInstance().purchaseItem(this, it)
        }
    }

    private fun increaseCoin(coin: Int) {
        firebaseAuth.currentUser?.uid?.let {
            preferenceHelper.getUser()?.coin?.let { c ->
                FirebaseHelper.setCoin(it, (c + coin))
            }
        }
    }

    private fun showMessage(message: String) {
        AlertDialog.Builder(this)
            .setTitle(R.string.app_name)
            .setMessage(message)
            .setPositiveButton(
                R.string.ok
            ) { _, _ ->
                // Continue with delete operation
            }
            .setIcon(R.mipmap.ic_launcher)
            .show()
    }

    private fun restore() {
        BillingHelper.getInstance().getOldSubscriptions {
            if (it != null) {
                setVip()
                finish()
            }
        }
    }

    private fun setVip() {
        FirebaseAuth.getInstance().currentUser?.let { firebaseUser ->
            FirebaseHelper.setVip(firebaseUser.uid, true)
            showMessage(getString(R.string.message_purchased_vip))
        }
    }
}