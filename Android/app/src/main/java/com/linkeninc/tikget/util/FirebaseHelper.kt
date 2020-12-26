package com.linkeninc.tikget.util

import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener
import com.google.gson.Gson
import com.linkeninc.tikget.Constant
import java.util.Date

object FirebaseHelper {

    private const val FIREBASE_DATABASE_URL = "tikget/account"
    private const val COIN = "coin"
    private const val LAST_ONLINE = "last_online"
    private const val VIP = "vip"

    private val firebaseDb = FirebaseDatabase.getInstance()

    fun getUserData(userId: String, onDone: ((String) -> Unit)?) {
        firebaseDb.reference.child(FIREBASE_DATABASE_URL).child(userId)
            .addValueEventListener(object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    onDone?.invoke(Gson().toJson(snapshot.value))
                }

                override fun onCancelled(error: DatabaseError) {

                }
            })
    }

    fun initUser(userId: String) {
        val db = firebaseDb.reference.child(FIREBASE_DATABASE_URL).child(userId)
        db.child(COIN).setValue(RemoteConfigHelper.getValueInt(Constant.KeyRemote.DAILY_COIN))
        db.child(VIP).setValue(false)
        db.child(LAST_ONLINE).setValue(DateTimeUtil.convertDateToString(Date()))
    }

    fun setCoin(userId: String, coin: Int) {
        firebaseDb.reference.child(FIREBASE_DATABASE_URL).child(userId).child(COIN).setValue(coin)
    }

    fun setVip(userId: String, isVip: Boolean) {
        firebaseDb.reference.child(FIREBASE_DATABASE_URL).child(userId).child(VIP).setValue(isVip)
    }

    fun setLastOnline(userId: String, lastOnline: String) {
        firebaseDb.reference.child(FIREBASE_DATABASE_URL).child(userId).child(LAST_ONLINE)
            .setValue(lastOnline)
    }
}