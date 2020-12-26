package com.linkeninc.tikget.ui.trending

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.linkeninc.tikget.R
import com.linkeninc.tikget.bus.BusEvent
import com.linkeninc.tikget.bus.BusHelper
import com.linkeninc.tikget.data.trending.UserTiktok
import com.linkeninc.tikget.extension.result
import com.linkeninc.tikget.interactor.AppInteractor
import kotlinx.android.synthetic.main.fragment_trending.edtSearch
import kotlinx.android.synthetic.main.fragment_trending.rvTopUsers
import org.greenrobot.eventbus.Subscribe


class TrendingFragment() : Fragment() {

    private lateinit var appInteractor: AppInteractor
    private var adapterUser: UserTiktokAdapter? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_trending, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        edtSearch.setOnEditorActionListener { _, actionId, _ ->
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                adapterUser?.clearSelected()
                val userName = edtSearch.text.toString().trim()
                if (userName.isNotEmpty()) {
                    getUserFeed(userName)
                }
            }
            false
        }
    }

    override fun onStart() {
        super.onStart()
        BusHelper.subscribe(this)
    }

    override fun onDestroy() {
        BusHelper.unsubscribe(this)
        super.onDestroy()
    }


    @Subscribe
    fun onReceivedData(event: BusEvent) {

    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        appInteractor = AppInteractor(context)
        getTrending()
    }

    private fun getTrending() {
        appInteractor.getTrending().result {
            doOnSuccess {
                showUser(it)
            }
        }
    }

    private fun getUserFeed(userName: String) {
        appInteractor.getUserFeed(userName).result {
            doOnSuccess {

            }
        }
    }

    private fun showUser(user: List<UserTiktok?>) {
        val listUser = arrayListOf<UserTiktok>()
        user.forEach { userTiktok -> userTiktok?.let { listUser.add(userTiktok) } }
        rvTopUsers.layoutManager = LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
        adapterUser = UserTiktokAdapter(rvTopUsers, listUser) {
            edtSearch.setText(it.subTitle?.replace("@", ""))
            edtSearch.clearFocus()
        }
        rvTopUsers.adapter = adapterUser
    }
}