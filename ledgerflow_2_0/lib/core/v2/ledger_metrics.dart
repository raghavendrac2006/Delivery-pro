import 'package:ledgerflow/core/models/models.dart';

class LedgerPeriod {
  final DateTime start;
  final DateTime end;

  const LedgerPeriod({required this.start, required this.end});

  bool contains(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    return !day.isBefore(startDay) && !day.isAfter(endDay);
  }
}

class LedgerCashSnapshot {
  final int salesCount;
  final int expenseCount;
  final double grossSales;
  final double paidSales;
  final double unpaidSales;
  final double customerPayments;
  final double expenses;

  const LedgerCashSnapshot({
    required this.salesCount,
    required this.expenseCount,
    required this.grossSales,
    required this.paidSales,
    required this.unpaidSales,
    required this.customerPayments,
    required this.expenses,
  });

  double get cashInHand => paidSales + customerPayments;
  double get netCashFlow => cashInHand - expenses;
  double get profitBeforePendingCollections => grossSales - expenses;
  double get collectionRate =>
      grossSales <= 0 ? 0 : (paidSales / grossSales) * 100;
}

class BagCycleSnapshot {
  final RiceBag bag;
  final double revenue;
  final double expenses;
  final double cashCollected;
  final double outstandingCollections;

  const BagCycleSnapshot({
    required this.bag,
    required this.revenue,
    required this.expenses,
    required this.cashCollected,
    required this.outstandingCollections,
  });

  double get profit => revenue - expenses;
  double get margin => revenue <= 0 ? 0 : (profit / revenue) * 100;
  double get cashAvailable => cashCollected - expenses;
}

class CollectionPriority {
  final Customer customer;
  final DateTime? lastActivityAt;

  const CollectionPriority({required this.customer, this.lastActivityAt});
}
