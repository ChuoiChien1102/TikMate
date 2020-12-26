package com.linkeninc.tikget.ui.tutorial

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.linkeninc.tikget.R
import kotlinx.android.synthetic.main.activity_tutorial.ivClose

class TutorialActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_tutorial)
        ivClose.setOnClickListener {
            finish()
        }
    }
}