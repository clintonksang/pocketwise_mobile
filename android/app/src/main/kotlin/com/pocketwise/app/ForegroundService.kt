package com.pocketwise.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity

class ForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "ForegroundServiceChannel"
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val notificationIntent = Intent(this, FlutterActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0)

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Service Active")
            .setContentText("Listening for SMS")
            .setSmallIcon(R.drawable.background)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(1, notification)

        // Continue to listen for SMS and other tasks
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }
}
