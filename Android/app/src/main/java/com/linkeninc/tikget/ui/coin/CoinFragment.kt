package com.linkeninc.tikget.ui.coin

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.linkeninc.tikget.Constant
import com.linkeninc.tikget.R
import com.linkeninc.tikget.api.helper.PreferenceHelper
import com.linkeninc.tikget.bus.BusEvent
import com.linkeninc.tikget.bus.BusHelper
import com.linkeninc.tikget.bus.EventType
import com.linkeninc.tikget.extension.setDebouncedOnClickListener
import com.linkeninc.tikget.ui.store.StoreActivity
import kotlinx.android.synthetic.main.fragment_coin.ivCoin
import kotlinx.android.synthetic.main.fragment_coin.layoutBuyCoin
import kotlinx.android.synthetic.main.fragment_coin.layoutBuyVip
import kotlinx.android.synthetic.main.fragment_coin.layoutWatchAds
import kotlinx.android.synthetic.main.fragment_coin.tvCoin
import org.greenrobot.eventbus.Subscribe


class CoinFragment : Fragment() {

    private lateinit var preferenceHelper: PreferenceHelper

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_coin, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        showData()
        layoutWatchAds.setDebouncedOnClickListener {
            BusHelper.showAds(false)
        }
        layoutBuyCoin.setDebouncedOnClickListener {
            showStore()
        }
        layoutBuyVip.setDebouncedOnClickListener {
            showStore(true)
        }
    }

    private fun showStore(isSub: Boolean = false) {
        val intent = Intent(context, StoreActivity::class.java)
        intent.putExtra(Constant.KEY_IS_SUB, isSub)
        startActivity(intent)
    }

    override fun onStart() {
        super.onStart()
        BusHelper.subscribe(this)
    }

    override fun onDestroy() {
        BusHelper.unsubscribe(this)
        super.onDestroy()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        preferenceHelper = PreferenceHelper(context)
    }

    @Subscribe
    fun onReceivedData(event: BusEvent) {
        when (event.eventType) {
            EventType.SHOW_DATA -> {
                showData()
            }
        }
    }

    private fun showData() {
        preferenceHelper.getUser()?.let {
            tvCoin.text = if (it.isVip) "VIP" else it.coin.toString()
            ivCoin.setImageResource(if (it.isVip) R.drawable.ic_vip else R.drawable.ic_coin)
        }
    }
}