package com.linkeninc.tikget.ui.trending

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.linkeninc.tikget.R
import com.linkeninc.tikget.data.trending.UserTiktok
import com.linkeninc.tikget.extension.setAvatar
import com.linkeninc.tikget.extension.setDebouncedOnClickListener
import kotlinx.android.synthetic.main.item_user.view.ivSelected
import kotlinx.android.synthetic.main.item_user.view.ivUser
import kotlinx.android.synthetic.main.item_user.view.tvName

class UserTiktokAdapter(
    private val recyclerView: RecyclerView,
    private val listUser: ArrayList<UserTiktok>,
    val userListener: (user: UserTiktok) -> Unit
) : RecyclerView.Adapter<UserTiktokAdapter.UserViewHolder>() {

    private var oldSelected = -1
    private var currentSelected = -1

    override fun onCreateViewHolder(
        container: ViewGroup,
        p1: Int
    ): UserViewHolder {
        return UserViewHolder(
            LayoutInflater.from(container.context).inflate(R.layout.item_user, container, false)
        )
    }

    override fun getItemCount(): Int = listUser.size

    override fun onBindViewHolder(holder: UserViewHolder, position: Int) {
        holder.bindData(listUser[position])
    }

    private fun invalidateSelected() {
        (recyclerView.findViewHolderForAdapterPosition(oldSelected) as? UserViewHolder)?.showSelected(
            false
        )
        (recyclerView.findViewHolderForAdapterPosition(currentSelected) as? UserViewHolder)?.showSelected(
            true
        )
    }

    fun clearSelected() {
        (recyclerView.findViewHolderForAdapterPosition(currentSelected) as? UserViewHolder)?.showSelected(
            false
        )
        oldSelected = -1
        currentSelected = -1
    }

    inner class UserViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bindData(user: UserTiktok) {
            showSelected(adapterPosition == currentSelected)
            itemView.ivUser.setAvatar(user.cover)
            itemView.tvName.text = user.title
            itemView.setDebouncedOnClickListener {
                oldSelected = currentSelected
                currentSelected = adapterPosition
                invalidateSelected()
                userListener.invoke(user)
            }
        }

        fun showSelected(isShow: Boolean) {
            if (isShow) {
                itemView.ivSelected.visibility = View.VISIBLE
            } else {
                itemView.ivSelected.visibility = View.GONE
            }
        }
    }
}
