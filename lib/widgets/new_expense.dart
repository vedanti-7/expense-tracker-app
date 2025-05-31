import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_drive/models/expense.dart'; //to use formatter imported from the intl.dart.

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController(); //the value stored in this property will be an object that is created with the help of the built in TextController class.
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory= Category.leisure; //default value set

  void _presentDatePicker() async {
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
    final enteredAmount= double.tryParse(_amountController.text); //tryParse('hello')=>null, tryParse('1.12')=> 1.12 string to double.
    final amountIsInvalid= enteredAmount== null || enteredAmount<=0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate==null) {   //trim removes white space from the beginning and the end.
      showDialog(context: context, builder: (ctx)=> AlertDialog(
        title: const Text('Invalid Input'),
        content: const Text('Please make sure a valid date, title, category and amount was entered..'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            }, 
            child: const Text("okay"),
          ),
        ],
      ), 
    );
    return; //make sure that no code is executed thereafter in that function.
    }

    widget.onAddExpense(Expense(   //special widget property, available in state class(generic class) to access properties of the widget class that belongs to your state class(generic class)
      title: _titleController.text, 
      amount: enteredAmount, 
      date: _selectedDate!, 
      category: _selectedCategory),
    );
    Navigator.pop(context);
  }


  @override
  void dispose() {
    //needed because then the texteditcontroller will live on in memory even when the widget is not visible anymore. it is automatically called by flutter whenever the widget and its state are about to be destroyed.
    _titleController.dispose(); //only state class can implement this dispose method here. this will tell flutter that this controller is not needed anymore otherwise it will cause apps to crash.
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace=MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx,constraints) {
      final width=constraints.maxWidth;
      

      return SizedBox(    //used so that we can allow the modal sheet to take up entire page or half page as it defaultly takes half as told oin below line but we can take it up to the whole screen too.
      height: double.infinity,
      child: SingleChildScrollView( //to make sure that the modal sheet with all the details of adding the new expense is scrollable. works better in landscape, the modal sheet takes up only half the page now.
        child: Padding(
          padding: EdgeInsets.fromLTRB(16,16,16,keyboardSpace+16), //from left,right,top,bottom.
          child: Column(
            children: [
              if(width>=600)
                Row(children: [
                  Expanded(child:TextField(
                  controller:_titleController, //function activated in this argument whenever any change is done in the textfield. later it is cut out and controller comes into picture for more info about it see above.
                  maxLength:50, // title of any expense shouldn't be greater than 50 characters.
                  decoration: const InputDecoration(
                    label: Text('title'),
                  ),
                ),
                ),
                const SizedBox(width: 24),
                Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('amount'),
                      ),
                    ),
                  ),
                ],)
              else
                TextField(
                  controller:_titleController, //function activated in this argument whenever any change is done in the textfield. later it is cut out and controller comes into picture for more info about it see above.
                  maxLength:50, // title of any expense shouldn't be greater than 50 characters.
                  decoration: const InputDecoration(
                    label: Text('title'),
                  ),
                ),
                if(width>=600)
                  Row(children: [],)
                else
                  Row(children: [
                    Expanded(
                      child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('amount'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .end, //to push the selected date button to the left
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No Date Selected'
                              : formatter.format(_selectedDate!),
                        ), //exclamation mark is added to tell that the value of _selectedDate is not null, if we dont do that then the _selectedDate cannot be formatted. with this we will see the picked date.
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory, //currently selected value will be shown on the screen.
                      items: Category.values.map(
                        (category) => DropdownMenuItem(
                          value: category, //this value will be passed down to onChanged function whenever one of the item is selected.
                          child: Text(
                            category.name.toUpperCase(), //to convert enum category values to uppercase string.
                          ),
                        ),
                      ).toList(),
                      onChanged: (value) {
                        if(value==null) { //if the IF statement would not have been put then value cannot be assigned to _selectedCategory as it sees that the user did not select anything, so we check value first if it is null or not. 
                          return;
                        }
                        setState(() { //updating the state whenever it changes. that is if the category is selected.
                          _selectedCategory= value; 
                        });
                      }),
                      const Spacer(),
        
                  TextButton(
                    onPressed: () {
                      //pop removes the modal overlay from the screen
                      Navigator.pop(context);
                    },
                    child: const Text('cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenseData,
                    child: const Text('save expense'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    });
  }
}
