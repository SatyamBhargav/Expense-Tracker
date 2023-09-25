import 'package:advance_perxtrack/model/expense.dart';
import 'package:flutter/material.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key, required this.onAddItems});
  final void Function(Expense expense) onAddItems;

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final _titleconroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  @override
  void dispose() {
    _titleconroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  void _datepicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountcontroller.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleconroller.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('okey'))
          ],
        ),
      );
      return;
    }
    widget.onAddItems(
      Expense(
        title: _titleconroller.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 35, left: 20, right: 20, bottom: keyboardSpace + 16),
              child: Column(children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleconroller,
                          maxLength: 20,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountcontroller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\₹ ',
                            labelText: 'Amount',
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleconroller,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      Text(
                        _selectedDate == null
                            ? 'No date selected'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                          onPressed: () {
                            _datepicker();
                          },
                          icon: const Icon(Icons.calendar_month_outlined)),
                    ],
                  )
                else
                  Row(
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 150,
                          child: TextField(
                            controller: _amountcontroller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\₹ ',
                              labelText: 'Amount',
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _selectedDate == null
                            ? 'No date selected'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                          onPressed: () {
                            _datepicker();
                          },
                          icon: const Icon(Icons.calendar_month_outlined))
                    ],
                  ),
                const SizedBox(
                  height: 30,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancle'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder()),
                        child: const Text('Save Expense'),
                      )
                    ],
                  )
                else
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancle'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder()),
                        child: const Text('Save Expense'),
                      )
                    ],
                  )
              ]),
            ),
          ),
        );
      },
    );
  }
}
