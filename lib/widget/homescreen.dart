import 'package:advance_perxtrack/additems.dart';
import 'package:advance_perxtrack/model/expense.dart';
import 'package:advance_perxtrack/widget/chart/chart.dart';
import 'package:advance_perxtrack/widget/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _registerexpense = [];

  void _openadditemspage() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => AddItems(onAddItems: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerexpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerexpense.indexOf(expense);
    setState(() {
      _registerexpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense Deleted'),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _registerexpense.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some.'),
    );

    if (_registerexpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registerexpense,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter ExpensiveTracker',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _openadditemspage();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600
          ? Column(children: [
              Chart(expenses: _registerexpense),
              Expanded(
                child: mainContent,
              ),
            ])
          : Row(children: [
              Expanded(child: Chart(expenses: _registerexpense)),
              Expanded(
                child: mainContent,
              ),
            ]),
    );
  }
}
