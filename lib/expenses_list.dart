import 'package:flutter/material.dart';
import 'package:test_drive/models/expense.dart';
import 'package:test_drive/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key,
      required this.expenses,
      required this.onRemoveExpense}
    ); //for accepting the list of expenses as input

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense; //takes a function as input, specified in the expenses.dart file.

  @override
  Widget build(BuildContext context) {
    return ListView.builder( //ListView used instead of column because we have a list of unclear length, so column cannot be used, we can set to a defualt value like till 100, but by doing that we only need a small amount of it so its simply redudant.
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(  //to make the content dismissible.
        key: ValueKey(expenses[index]), //to make widgets and its data uniquely identifiable. to make sure that the correct data is entered here.
        background: Container(color: Theme.of(context).colorScheme.error, margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),),
        onDismissed: (direction) {  //what will happen if we swipe to left direction or right direction.
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(expenses[index]),  //all of the dismissible section also allows us to reload our expenses.
      ),
    ); 
  }
}
