import 'package:expenses/components/single_transaction.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final Function deleteTransaction;
  final List<Transaction> transactions;
  TransactionList(this.transactions, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return transactions.isEmpty
          ? Column(
              children: [
                Text('No expenses added yet'),
                SizedBox(
                  height: constraints.maxHeight *0.05,
                ),
                Container(
                  height: constraints.maxHeight *0.8,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2.0,
                  child: SingleTransaction(
                    id: transactions[index].id,
                    title: transactions[index].title,
                    amount: transactions[index].amount,
                    date: transactions[index].date,
                    deleteTransaction: deleteTransaction,
                  ),
                );
              },
              itemCount: transactions.length,
            );
    });
  }
}
