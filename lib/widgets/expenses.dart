import 'package:flutter/material.dart';
import 'package:test_drive/expenses_list.dart';
import 'package:test_drive/models/expense.dart';
import 'package:test_drive/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,  //provides features such as camera not interfering the UI. scaffold widgets do it automatically
      isScrollControlled: true, //so that the automatic keyboard closes and doesn't overlap our inputs.
      context: context,
      builder: (ctx) => NewExpense(onAddExpense:_addExpense),
    );
  }

  void _addExpense(Expense expense) {  //using our custok class as a type here.
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) { //function made so that whenever we swipe away any expense, changes are made into the _registerdexpenses list
  final expenseIndex=_registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(     //basically used to print message whenever the list is empty and some of the arguments under it allows to undo the action of bringing back any expense.
        duration: const Duration(seconds: 3),
        content: const Text("expense deleted"),
        action: SnackBarAction(
          label: "undo", 
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex,expense); //to re-insert the last deleted expense.
            });
          }
        ),
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.of(context).size.width; //hover over for more information.
    
    Widget mainContent= const Center(child: Text("No expenses found, start adding some"),); //if no expenses are there.

    if(_registeredExpenses.isNotEmpty){
      mainContent= ExpensesList(expenses: _registeredExpenses,onRemoveExpense: _removeExpense,);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      
      body: width<600 ? Column(
        children: [
          const SizedBox(height: 20),
          const Text("the chart"),
          Expanded(
            child: mainContent, // what is written in mainContent was written here, but taken there is the registeredexpenses is not empty so the action will be done to store the expenses.
          ),
        ],
      ):Row(children: [
        Expanded(
            child: mainContent, // what is written in mainContent was written here, but taken there is the registeredexpenses is not empty so the action will be done to store the expenses.
          ),
      ]),
    );
  }
}
