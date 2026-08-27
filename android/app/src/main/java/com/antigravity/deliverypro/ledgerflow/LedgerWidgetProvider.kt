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
                
                // Intent for Sell 1rs Chakli
                val sell1rsIntent = Intent(context, MainActivity::class.java).apply {
                    data = Uri.parse("ledgerflow://action?type=sale&item=1_rs_chakli")
                    action = Intent.ACTION_VIEW
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingSell1rs = PendingIntent.getActivity(context, 1, sell1rsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
                setOnClickPendingIntent(R.id.btn_sell_1rs, pendingSell1rs)

                // Intent for Sell 5rs Chakli
                val sell5rsIntent = Intent(context, MainActivity::class.java).apply {
                    data = Uri.parse("ledgerflow://action?type=sale&item=5_rs_chakli")
                    action = Intent.ACTION_VIEW
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingSell5rs = PendingIntent.getActivity(context, 2, sell5rsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
                setOnClickPendingIntent(R.id.btn_sell_5rs, pendingSell5rs)

                // Intent for Custom New Sale
                val newSaleIntent = Intent(context, MainActivity::class.java).apply {
                    data = Uri.parse("ledgerflow://action?type=sale&item=custom")
                    action = Intent.ACTION_VIEW
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingNewSale = PendingIntent.getActivity(context, 3, newSaleIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
                setOnClickPendingIntent(R.id.btn_new_sale, pendingNewSale)

                // Intent for Add Expense
                val expenseIntent = Intent(context, MainActivity::class.java).apply {
                    data = Uri.parse("ledgerflow://action?type=expense")
                    action = Intent.ACTION_VIEW
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingExpense = PendingIntent.getActivity(context, 4, expenseIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
                setOnClickPendingIntent(R.id.btn_add_expense, pendingExpense)

                // Intent for Clients List
                val clientsIntent = Intent(context, MainActivity::class.java).apply {
                    data = Uri.parse("ledgerflow://action?type=clients")
                    action = Intent.ACTION_VIEW
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingClients = PendingIntent.getActivity(context, 5, clientsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
                setOnClickPendingIntent(R.id.btn_clients, pendingClients)

                // Intent for Summary
                val summaryIntent = Intent(context, MainActivity::class.java).apply {
                    data = Uri.parse("ledgerflow://action?type=summary")
                    action = Intent.ACTION_VIEW
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingSummary = PendingIntent.getActivity(context, 6, summaryIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
                setOnClickPendingIntent(R.id.btn_summary, pendingSummary)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
