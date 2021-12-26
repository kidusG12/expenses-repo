import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseInput extends StatefulWidget {
  final Function addNewTransaction;
  ExpenseInput(this.addNewTransaction);

  @override
  State<ExpenseInput> createState() => _ExpenseInputState();
}

class _ExpenseInputState extends State<ExpenseInput> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _enteredDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _enteredDate == null) {
      return;
    }
    widget.addNewTransaction(enteredTitle, enteredAmount, _enteredDate);

    Navigator.of(context).pop();
  }

  void _pickDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _enteredDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: 20.0,
            top: 20.0,
            right: 20.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              autocorrect: true,
              decoration: InputDecoration(labelText: 'Title'),
              onSubmitted: (_) => _submitData(),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            SizedBox(height: 40.0),
            Row(children: [
              _enteredDate == null
                  ? SizedBox()
                  : Card(
                      elevation: 5,
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Picked date: ${DateFormat.yMEd().format(_enteredDate!)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  _pickDate();
                },
                child: Row(
                  children: [
                    Text('Pick a date'),
                    SizedBox(width: 10.0),
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ]),
            SizedBox(height: 60.0),
            Container(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepOrange),
                child: FlatButton(
                    onPressed: () => _submitData(),
                    textColor: Colors.white,
                    child: Text('Add Expense')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
