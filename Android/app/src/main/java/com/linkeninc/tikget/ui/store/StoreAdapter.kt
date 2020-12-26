package com.linkeninc.tikget.ui.store

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.android.billingclient.api.SkuDetails
import com.linkeninc.tikget.Constant
import com.linkeninc.tikget.R
import com.linkeninc.tikget.extension.setDebouncedOnClickListener
import kotlinx.android.synthetic.main.item_store.view.ivCoin
import kotlinx.android.synthetic.main.item_store.view.tvCoin
import kotlinx.android.synthetic.main.item_store.view.tvPrice

class StoreAdapter(private val data: MutableList<StoreItem>, private val listener: StoreListener) :
    RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return if (viewType == 1) {
            TitleViewHolder(
                LayoutInflater.from(parent.context)
                    .inflate(R.layout.item_store_title, parent, false)
            )
        } else {
            StoreViewHolder(
                LayoutInflater.from(parent.context).inflate(R.layout.item_store, parent, false)
            )
        }
    }

    override fun getItemViewType(position: Int): Int {
        return if (data[position].title == null) {
            0
        } else {
            1
        }
    }

    override fun getItemCount(): Int = data.size

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        if (holder is StoreViewHolder) {
            holder.bindData(data[position])
        }
    }

    fun setData(list: MutableList<StoreItem>) {
        data.clear()
        data.addAll(list)
        notifyDataSetChanged()
    }

    inner class StoreViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        @SuppressLint("SetTextI18n")
        fun bindData(storeItem: StoreItem) {
            val context = itemView.context
            val skuDetails = storeItem.skuDetails
            if (storeItem.type == 0) {
                itemView.ivCoin.visibility = View.GONE
                itemView.tvCoin.text = getPeriodText(context, skuDetails)
            } else {
                itemView.ivCoin.visibility = View.VISIBLE
                itemView.tvCoin.text =
                    context.getString(
                        R.string.coin_value,
                        (storeItem.coin ?: 0).toString()
                    )
            }
            itemView.tvPrice.text = skuDetails?.price ?: ""
            itemView.tvPrice.setDebouncedOnClickListener {
                listener.onClickItem(storeItem)
            }
        }

        private fun getPeriodText(context: Context, skuDetails: SkuDetails?): String {
            if (skuDetails == null) {
                return ""
            }
            val freeTrial = getFreeTrial(skuDetails.freeTrialPeriod).toString()
            val resDes = when (skuDetails.sku) {
                Constant.Subscription.ONE_MONTH -> R.string.one_month
                Constant.Subscription.THREE_MONTHS -> R.string.three_month
                else -> R.string.one_week
            }
            return context.getString(resDes) + "\n" + context.getString(
                R.string.free_trial,
                freeTrial
            )
        }

        private fun getFreeTrial(freeTrialPeriod: String): Int {
            return try {
                freeTrialPeriod.substring(1, 2).toInt()
            } catch (e: Exception) {
                0
            }
        }
    }

    inner class TitleViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        @SuppressLint("SetTextI18n")
        fun bindData(storeItem: StoreItem) {
            itemView.tvPrice.text = storeItem.title ?: ""
        }
    }

    interface StoreListener {
        fun onClickItem(item: StoreItem)
    }
}