package com.pocketwise.app

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import com.pocketwise.app.R

class NotificationHandler(private val context: Context) {
    private val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    fun showIncomeNotification(amount: String) {
        val remoteViews = RemoteViews(context.packageName, R.layout.income_notification)
        remoteViews.setTextViewText(R.id.tvQuestion, "add KSH $amount transaction to income?")

        // Setup action buttons
        val yesIntent = PendingIntent.getActivity(context, 0, Intent(context, YourActivity::class.java), PendingIntent.FLAG_UPDATE_CURRENT)
        val noIntent = PendingIntent.getActivity(context, 1, Intent(context, YourActivity::class.java), PendingIntent.FLAG_UPDATE_CURRENT)

        remoteViews.setOnClickPendingIntent(R.id.btnYes, yesIntent)
        remoteViews.setOnClickPendingIntent(R.id.btnNo, noIntent)

        val notification = NotificationCompat.Builder(context, "YOUR_CHANNEL_ID")
            .setSmallIcon(R.drawable.ic_notification)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(remoteViews)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

        notificationManager.notify(1, notification)
    }
}
