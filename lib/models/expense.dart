import 'package:uuid/uuid.dart'; //gives a class or an object
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter= DateFormat.yMd();

const uuid = Uuid();

enum Category {food,travel,leisure,work} // enum is the combination of predefined allowed values. it is made for the category variable bcoz to set a fixed set of categories.

const categoryIcons={
  Category.food: Icons.food_bank,
  Category.travel: Icons.flight_sharp,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4(); // id= uuid.v4() generated a unique id and assigns it as an initial value to the id property whenevr this expense class is initialized.

  final String id; //to identfy the expense
  final String title; //what expense?
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {          //for chart     
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category): expenses=      //additional/alternative constructor function, user-defined/made. this is used for dividing expenses per category. 
  allExpenses.where((expense) => expense.category==category).toList();  //if the expense.category(the predefined category of expenses) is equal to the category taken as input from the user in this expense bucket, then it is taken or else not.  

  final Category category;
  final List<Expense> expenses;

 double get totalExpense {     //for getting total expense per bucket, we will have one bucket for each category.
  double sum=0;

  for(final expense in expenses) {
    sum=sum+expense.amount;
  }

  return sum;
 } 
}
