package com.example.yourassisstant

import android.annotation.TargetApi
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    @TargetApi(Build.VERSION_CODES.DONUT)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.e("main","yes")
        val intent = Intent(this, WhatsappAccessibilityService::class.java)
        startService(intent)
        GeneratedPluginRegistrant.registerWith(this)
        val channel1 = BasicMessageChannel<String>(flutterView, "reply", StringCodec.INSTANCE)
        val channel2 = BasicMessageChannel<String>(flutterView, "title", StringCodec.INSTANCE)
        channel1.setMessageHandler { message, reply ->
            reply.reply(message)
            channel2.setMessageHandler { title, send ->
                send.reply(title)
                val number = title?.replace("+", "")?.replace(" ", "").toString()
                val sendIntent = Intent("android.intent.action.MAIN")
                sendIntent.data = Uri.parse("https://api.whatsapp.com/send?phone=$number")
                sendIntent.putExtra("jid", "$number@s.whatsapp.net")
                sendIntent.putExtra(Intent.EXTRA_TEXT, "$message ")
                sendIntent.type = "text/plain"
                sendIntent.action = Intent.ACTION_SEND
                sendIntent.setPackage("com.whatsapp")
                startActivity(sendIntent)
            }
        }
    }
}

