import 'dart:io';
import 'package:expenses/provider/expense_provider.dart';
import 'package:expenses/widgets/chart.dart';
import 'package:expenses/widgets/expense_input.dart';
import 'package:expenses/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void loadData() async {
    await Provider.of<Transactions>(context).fetchAndSetPlaces();
    setState(() {
      _isLoading = false;
    });
  }

  // final List<Transaction> _transactions = [];
  // List<Transaction> get _recentTransactions {
  //   return _transactions.where((tx) {
  //     return tx.date.isAfter(DateTime.now().subtract(
  //       Duration(days: 7),
  //     ));
  //   }).toList();
  // }
  //
  // void _addNewTransaction(String title, double amount, DateTime date) {
  //   final newTx = Transaction(
  //       title: title,
  //       amount: amount,
  //       date: date,
  //       id: DateTime.now().toString());
  //   setState(() {
  //     _transactions.add(newTx);
  //   });
  // }
  //
  // void _deleteTransaction(String id) {
  //   setState(() {
  //     _transactions.removeWhere((tx) => tx.id == id);
  //   });
  // }

  // void startAddNewTransaction(BuildContext ctx) {
  //   showModalBottomSheet(
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
  //       context: ctx,
  //       builder: (_) {
  //         return ExpenseInput(_addNewTransaction);
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final transactionData = Provider.of<Transactions>(context);

    void startAddNewTransaction(BuildContext ctx) {
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          context: ctx,
          builder: (_) {
            return ExpenseInput(transactionData.addNewTransaction);
          });
    }

    final appBar = AppBar(
      title: const Text('personal expenses'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              startAddNewTransaction(context);
            },
            icon: const Icon(
              Icons.add_sharp,
              color: Colors.deepOrange,
            ),
          ),
        ),
      ],
    );

    final _txWidget = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.67,
        child: TransactionList(
            transactionData.transactions, transactionData.deleteTransaction));

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      if (isLandscape)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Show chart'),
                            Switch(
                                value: _showChart,
                                onChanged: (val) {
                                  setState(() {
                                    _showChart = val;
                                  });
                                }),
                          ],
                        ),
                      if (isLandscape)
                        _showChart
                            ? SizedBox(
                                height: (mediaQuery.size.height -
                                        appBar.preferredSize.height -
                                        mediaQuery.padding.top) *
                                    0.7,
                                child:
                                    Chart(transactionData.recentTransactions))
                            : _txWidget,
                      if (!isLandscape)
                        SizedBox(
                            height: (mediaQuery.size.height -
                                    appBar.preferredSize.height -
                                    mediaQuery.padding.top) *
                                0.33,
                            child: Chart(transactionData.recentTransactions)),
                      if (!isLandscape) _txWidget,
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                startAddNewTransaction(context);
              },
              child: const Icon(Icons.add_sharp),
            ),
    );
  }
}
