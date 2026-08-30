import 'package:ledgerflow/core/models/models.dart';
import 'ledger_metrics.dart';

class LedgerMetricsCalculator {
  const LedgerMetricsCalculator();

  LedgerCashSnapshot cashSnapshot({
    required List<DeliveryLog> logs,
    required List<ExpenseLog> expenses,
    required LedgerPeriod period,
    String productName = 'All',
  }) {
    final includeAllProducts = productName.toLowerCase() == 'all';

    final periodSales = logs.where((log) {
      if (log.isPayment || !period.contains(log.dateTime)) {
        return false;
      }
      return includeAllProducts ||
          log.itemName.toLowerCase() == productName.toLowerCase();
    }).toList();

    final periodPayments = logs.where((log) {
      return log.isPayment && period.contains(log.dateTime);
    }).toList();

    final periodExpenses = expenses.where((expense) {
      final parsedDate = DateTime.tryParse(expense.date);
      return parsedDate != null && period.contains(parsedDate);
    }).toList();

    final grossSales = _sumDeliveryAmounts(periodSales);
    final paidSales = _sumDeliveryAmounts(
      periodSales.where((log) => log.isPaid),
    );
    final customerPayments = _sumDeliveryAmounts(periodPayments);
    final expenseTotal = _sumExpenseAmounts(periodExpenses);

    return LedgerCashSnapshot(
      salesCount: periodSales.length,
      expenseCount: periodExpenses.length,
      grossSales: grossSales,
      paidSales: paidSales,
      unpaidSales: grossSales - paidSales,
      customerPayments: customerPayments,
      expenses: expenseTotal,
    );
  }

  BagCycleSnapshot bagSnapshot({
    required RiceBag bag,
    required List<DeliveryLog> logs,
    required List<ExpenseLog> expenses,
  }) {
    final bagSales = logs.where((log) {
      return !log.isPayment && log.associatedBagId == bag.bagId;
    }).toList();

    final bagExpenses = expenses.where((expense) {
      return expense.associatedBagId == bag.bagId;
    }).toList();

    final revenue = _sumDeliveryAmounts(bagSales);
    final cashCollected = _sumDeliveryAmounts(
      bagSales.where((log) => log.isPaid),
    );

    return BagCycleSnapshot(
      bag: bag,
      revenue: revenue,
      expenses: _sumExpenseAmounts(bagExpenses),
      cashCollected: cashCollected,
      outstandingCollections: revenue - cashCollected,
    );
  }

  List<CollectionPriority> collectionPriorities({
    required List<Customer> customers,
    required List<DeliveryLog> logs,
  }) {
    final pendingCustomers = customers
        .where((customer) => customer.outstanding > 0)
        .map((customer) {
          final customerLogs =
              logs
                  .where(
                    (log) =>
                        log.customerName.toLowerCase() ==
                        customer.name.toLowerCase(),
                  )
                  .toList()
                ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

          return CollectionPriority(
            customer: customer,
            lastActivityAt: customerLogs.isEmpty
                ? null
                : customerLogs.first.dateTime,
          );
        })
        .toList();

    pendingCustomers.sort((a, b) {
      final amountCompare = b.customer.outstanding.compareTo(
        a.customer.outstanding,
      );
      if (amountCompare != 0) {
        return amountCompare;
      }
      final aDate = a.lastActivityAt;
      final bDate = b.lastActivityAt;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });

    return pendingCustomers;
  }

  double _sumDeliveryAmounts(Iterable<DeliveryLog> logs) {
    return logs.fold(0, (total, log) => total + log.amount);
  }

  double _sumExpenseAmounts(Iterable<ExpenseLog> expenses) {
    return expenses.fold(0, (total, expense) => total + expense.amount);
  }
}
