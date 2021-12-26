import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleTransaction extends StatelessWidget {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Function deleteTransaction;

  SingleTransaction(
      {required this.title,
      required this.amount,
      required this.date,
      required this.id,
      required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
          builder: (ctx, constraints) {
            return ListTile(
              leading: Card(
                  elevation: 7,
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    width: constraints.maxWidth * 0.3,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),

                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: constraints.maxWidth * 0.7,
                                child: FittedBox(
                                    child: Text(
                                  amount.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 38, color: Colors.deepOrange),
                                ))),
                            SizedBox(width: constraints.maxWidth * 0.05),
                            Container(
                                width: constraints.maxWidth * 0.25,
                                child: FittedBox(
                                    child: Text(
                                  'birr',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.deepOrange),
                                ))),
                          ],
                        );
                      },
                    ),
                  )),
              title: Container(
                  width: constraints.maxWidth * 0.6, child: Text('${title}')),
              subtitle: Container(
                  width: constraints.maxWidth * 0.6,
                  child: Text('On ${DateFormat.yMEd().format(date)}')),
              trailing: Container(
                width: constraints.maxWidth * 0.1,
                child: IconButton(
                  color: Theme.of(context).errorColor,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteTransaction(id);
                  },
                ),
              ),
            );
          },
        );
  }
}
