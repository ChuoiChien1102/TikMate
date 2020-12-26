package com.linkeninc.tikget.ui.store

import com.android.billingclient.api.SkuDetails

class StoreItem(
    var skuDetails: SkuDetails? = null,
    var coin: Int? = null,
    var type: Int = 0,// 0-sub, 1-consumable
    var title: String? = null
)