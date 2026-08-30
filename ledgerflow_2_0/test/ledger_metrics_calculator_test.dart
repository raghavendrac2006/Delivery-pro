import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgerflow/core/models/models.dart';
import 'package:ledgerflow/core/v2/v2.dart';

void main() {
  group('LedgerMetricsCalculator', () {
    const calculator = LedgerMetricsCalculator();

    test('cashSnapshot separates sales, payments, expenses, and cash flow', () {
      final period = LedgerPeriod(
        start: DateTime(2026, 8, 1),
        end: DateTime(2026, 8, 31),
      );

      final logs = [
        _sale(amount: 500, isPaid: true, dateTime: DateTime(2026, 8, 10)),
        _sale(amount: 300, isPaid: false, dateTime: DateTime(2026, 8, 10)),
        _payment(amount: 200, dateTime: DateTime(2026, 8, 11)),
        _sale(amount: 900, isPaid: true, dateTime: DateTime(2026, 7, 31)),
      ];

      final expenses = [
        _expense(amount: 150, date: '2026-08-10'),
        _expense(amount: 75, date: '2026-08-12'),
        _expense(amount: 1000, date: '2026-09-01'),
      ];

      final snapshot = calculator.cashSnapshot(
        logs: logs,
        expenses: expenses,
        period: period,
      );

      expect(snapshot.salesCount, 2);
      expect(snapshot.expenseCount, 2);
      expect(snapshot.grossSales, 800);
      expect(snapshot.paidSales, 500);
      expect(snapshot.unpaidSales, 300);
      expect(snapshot.customerPayments, 200);
      expect(snapshot.expenses, 225);
      expect(snapshot.cashInHand, 700);
      expect(snapshot.netCashFlow, 475);
      expect(snapshot.collectionRate, 62.5);
    });

    test('bagSnapshot calculates one production cycle only', () {
      final bag = RiceBag(
        bagId: 'BAG_1',
        totalKg: 25,
        remainingKg: 10,
        startDate: '1 August 2026',
        cost: 1000,
      );

      final snapshot = calculator.bagSnapshot(
        bag: bag,
        logs: [
          _sale(amount: 800, isPaid: true, bagId: 'BAG_1'),
          _sale(amount: 200, isPaid: false, bagId: 'BAG_1'),
          _sale(amount: 500, isPaid: true, bagId: 'BAG_2'),
        ],
        expenses: [
          _expense(amount: 250, bagId: 'BAG_1'),
          _expense(amount: 99, bagId: 'BAG_2'),
        ],
      );

      expect(snapshot.revenue, 1000);
      expect(snapshot.expenses, 250);
      expect(snapshot.profit, 750);
      expect(snapshot.cashCollected, 800);
      expect(snapshot.outstandingCollections, 200);
      expect(snapshot.cashAvailable, 550);
      expect(snapshot.margin, 75);
    });

    test(
      'collectionPriorities sorts pending customers by highest balance first',
      () {
        final priorities = calculator.collectionPriorities(
          customers: [
            _customer('Clean Shop', 0),
            _customer('Small Due', 200),
            _customer('Big Due', 1500),
          ],
          logs: [
            _sale(
              customerName: 'Small Due',
              amount: 200,
              dateTime: DateTime(2026, 8, 20),
            ),
            _sale(
              customerName: 'Big Due',
              amount: 1500,
              dateTime: DateTime(2026, 8, 18),
            ),
          ],
        );

        expect(priorities.map((entry) => entry.customer.name), [
          'Big Due',
          'Small Due',
        ]);
      },
    );
  });
}

DeliveryLog _sale({
  String customerName = 'Test Customer',
  double amount = 100,
  bool isPaid = true,
  DateTime? dateTime,
  String? bagId,
}) {
  final effectiveDate = dateTime ?? DateTime(2026, 8, 10);
  return DeliveryLog(
    serialNo: effectiveDate.millisecondsSinceEpoch,
    date: '10 Aug 2026',
    dateTime: effectiveDate,
    itemName: 'Nippat',
    customerName: customerName,
    amount: amount,
    isPaid: isPaid,
    associatedBagId: bagId,
  );
}

DeliveryLog _payment({double amount = 100, DateTime? dateTime}) {
  final effectiveDate = dateTime ?? DateTime(2026, 8, 10);
  return DeliveryLog(
    serialNo: effectiveDate.millisecondsSinceEpoch,
    date: '10 Aug 2026',
    dateTime: effectiveDate,
    itemName: 'Cash Collected',
    customerName: 'Test Customer',
    amount: amount,
    isPaid: true,
    isPayment: true,
  );
}

ExpenseLog _expense({
  double amount = 100,
  String date = '2026-08-10',
  String? bagId,
}) {
  return ExpenseLog(
    itemName: 'Diesel',
    category: 'General',
    amount: amount,
    date: date,
    associatedBagId: bagId,
  );
}

Customer _customer(String name, double outstanding) {
  return Customer(
    name: name,
    type: 'RETAIL',
    area: '',
    outstanding: outstanding,
    icon: Icons.store,
  );
}
