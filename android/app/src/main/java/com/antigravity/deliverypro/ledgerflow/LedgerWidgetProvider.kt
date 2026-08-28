package com.antigravity.deliverypro.ledgerflow

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class LedgerWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.ledger_widget).apply {

                // Helper to create pending intents
                fun createPendingIntent(uriString: String, requestCode: Int): PendingIntent {
                    val intent = Intent(context, MainActivity::class.java).apply {
                        data = Uri.parse(uriString)
                        action = Intent.ACTION_VIEW
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    }
                    return PendingIntent.getActivity(
                        context,
                        requestCode,
                        intent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                }

                // 1. Header Bar -> Summary Screen
                setOnClickPendingIntent(R.id.header_bar, createPendingIntent("ledgerflow://action?type=summary", 101))

                // 2. Select Customer -> Sales Entry Screen
                setOnClickPendingIntent(R.id.btn_select_customer, createPendingIntent("ledgerflow://action?type=sale&item=select_customer", 102))

                // 3. + ₹200 Quick Sale Button
                setOnClickPendingIntent(R.id.btn_sell_200, createPendingIntent("ledgerflow://action?type=sale&amount=200", 103))

                // 4. + ₹500 Quick Sale Button
                setOnClickPendingIntent(R.id.btn_sell_500, createPendingIntent("ledgerflow://action?type=sale&amount=500", 104))

                // 5. Custom Amount Button
                setOnClickPendingIntent(R.id.btn_custom_amount, createPendingIntent("ledgerflow://action?type=sale&item=custom", 105))

                // 6. Paid Filter Toggle
                setOnClickPendingIntent(R.id.btn_status_paid, createPendingIntent("ledgerflow://action?type=sale&filter=paid", 106))

                // 7. Not Paid Filter Toggle
                setOnClickPendingIntent(R.id.btn_status_unpaid, createPendingIntent("ledgerflow://action?type=sale&filter=unpaid", 107))

                // 8. Recent Delivery Card -> Client List Screen
                setOnClickPendingIntent(R.id.btn_recent_delivery, createPendingIntent("ledgerflow://action?type=clients", 108))

                // 9. Add Expense Button -> Expenses Screen
                setOnClickPendingIntent(R.id.btn_add_expense, createPendingIntent("ledgerflow://action?type=expense", 109))
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
