import 'package:expenses/helper/db_helper.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    return [..._transactions];
  }

  List<Transaction> get recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: date,
        id: DateTime.now().toString());
    _transactions.insert(0, newTx);
    notifyListeners();

    DBHelper.insert('expenses', {
      'id': newTx.id,
      'title': newTx.title,
      'amount' : newTx.amount.toString(),
      'date' : newTx.date.toIso8601String()
    });
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((tx) => tx.id == id);
    notifyListeners();

    DBHelper.removeTransaction('expenses', id);
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('expenses');
    _transactions = dataList.reversed.map((e) => Transaction(
      id: e['id'],
      title: e['title'],
      amount: double.parse(e['amount']),
      date: DateTime.parse(e['date']),
    )).toList();
    notifyListeners();
  }

}
