import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_theme.dart';
import 'bento_card.dart';

class CurrentBagPerformanceWidget extends StatelessWidget {
  final double revenue;
  final double expenses;
  final double profit;
  final double cashAvailable;
  final double outstandingCollections;
  final double cashCollected;

  const CurrentBagPerformanceWidget({
    super.key,
    required this.revenue,
    required this.expenses,
    required this.profit,
    required this.cashAvailable,
    required this.outstandingCollections,
    required this.cashCollected,
  });

  @override
  Widget build(BuildContext context) {
    final formattedProfit = "₹${NumberFormat('#,##,###.00').format(profit)}";
    final formattedRevenue = "₹${NumberFormat('#,##,###').format(revenue)}";
    final formattedExpenses = "₹${NumberFormat('#,##,###').format(expenses)}";
    final formattedCashAvailable = "₹${NumberFormat('#,##,###').format(cashAvailable)}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BentoCard(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: AppTheme.surface,
          shadowStyle: ShadowStyle.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CURRENT BAG NET PROFIT",
                      style: AppTheme.labelSm.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      formattedProfit,
                      style: AppTheme.headlineXl.copyWith(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: profit >= 0 ? AppTheme.success : AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                profit >= 0 ? Icons.trending_up : Icons.trending_down,
                color: profit >= 0 ? AppTheme.success : AppTheme.error,
                size: 28.0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryCard(
                "REVENUE",
                formattedRevenue,
                AppTheme.primary,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: _buildSecondaryCard(
                "EXPENSES",
                formattedExpenses,
                AppTheme.error,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: GestureDetector(
                onLongPress: () => _showCashAvailableBottomSheet(context),
                child: _buildSecondaryCard(
                  "CASH AVAILABLE",
                  formattedCashAvailable,
                  cashAvailable >= 0 ? AppTheme.success : AppTheme.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryCard(String label, String value, Color valueColor) {
    return BentoCard(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      backgroundColor: AppTheme.surface,
      shadowStyle: ShadowStyle.light,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.labelSm.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: AppTheme.dataTabular.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showCashAvailableBottomSheet(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##,###');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handlebar
              Center(
                child: Container(
                  width: 40.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: AppTheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cash Available",
                    style: AppTheme.headlineMd.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24.0, color: AppTheme.outlineVariant),

              // Breakdown rows
              _buildBreakdownRow("Revenue", "₹${currencyFormatter.format(revenue)}"),
              const SizedBox(height: 12.0),
              _buildBreakdownRow("Outstanding Payments", "- ₹${currencyFormatter.format(outstandingCollections)}", isSubtle: true),
              const SizedBox(height: 8.0),
              const Divider(height: 16.0, thickness: 1.0, color: AppTheme.outlineVariant),
              const SizedBox(height: 8.0),
              
              _buildBreakdownRow("Cash Collected", "₹${currencyFormatter.format(cashCollected)}", isBold: true),
              const SizedBox(height: 12.0),
              _buildBreakdownRow("Less Expenses", "- ₹${currencyFormatter.format(expenses)}", isSubtle: true),
              const SizedBox(height: 8.0),
              const Divider(height: 16.0, thickness: 1.0, color: AppTheme.outlineVariant),
              const SizedBox(height: 8.0),

              _buildBreakdownRow(
                "Cash Available", 
                "₹${currencyFormatter.format(cashAvailable)}", 
                isBold: true,
                valueColor: cashAvailable >= 0 ? AppTheme.success : AppTheme.error
              ),
              
              const SizedBox(height: 24.0),
              const Divider(height: 8.0, color: AppTheme.outlineVariant),
              const SizedBox(height: 16.0),

              // Info Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cash Collected",
                    style: AppTheme.labelSm.copyWith(
                      color: AppTheme.onSurfaceVariant,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "₹${currencyFormatter.format(cashCollected)} / ₹${currencyFormatter.format(revenue)}",
                    style: AppTheme.dataTabular.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurface,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool isBold = false, bool isSubtle = false, Color? valueColor}) {
    final style = isBold 
        ? AppTheme.labelBold.copyWith(fontSize: 15.0)
        : AppTheme.labelSm.copyWith(
            fontSize: 14.0, 
            color: isSubtle ? AppTheme.onSurfaceVariant : AppTheme.onSurface
          );
          
    final valStyle = AppTheme.dataTabular.copyWith(
      fontSize: 15.0,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: valueColor ?? (isSubtle ? AppTheme.onSurfaceVariant : AppTheme.onSurface),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: valStyle),
      ],
    );
  }
}
