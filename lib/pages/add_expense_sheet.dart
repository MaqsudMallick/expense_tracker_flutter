import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class AddExpenseSheet extends StatefulWidget{
  const AddExpenseSheet(this.addExpense, {super.key});
  final void Function(Expense expense) addExpense;
  @override
  State<AddExpenseSheet> createState() {
    return _AddExpenseSheet();
  }
}

class _AddExpenseSheet extends State<AddExpenseSheet>{
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _datePicked;
  Category? _category = Category.food;
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
        child: Column(children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title')
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                decoration: const InputDecoration(
                  label: Text('Amount'),
                  prefixText: '\$ '
                ),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ), 
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_datePicked==null?'No date selected':dateFormat.format(_datePicked!)),
                    IconButton(onPressed: () {
                      final today = DateTime.now();
                      showDatePicker(
                        context: context, 
                        firstDate: DateTime(today.year-5), 
                        lastDate: today).then((value) {
                        setState(() {
                          _datePicked = value;
                        });
                      });
                    }, 
                    icon: const Icon(Icons.calendar_month),
                    )
                  ]
                ) 
              )
            ],
          ),
          
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton(
                value: _category ?? Category.food,
                items: Category.values.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase())
                  )).toList(), 
                onChanged: (value) {
                  setState(() {
                    _category = value;                    
                  });
                }
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text);
                  bool check = _titleController.text.trim().isEmpty;
                  check = check || amount==null;
                  check = check || amount<=0;
                  check = check || _category==null || _datePicked==null;
                  if(check){
                    showDialog(
                      context: context, 
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Please make sure a valid title, amount, date and category are entered'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                              }, 
                              child: const Text('okay')
                            )
                          ],
                          );
                    });
                    return;
                  }
                  //...
                  widget.addExpense(Expense(
                    title: _titleController.text, 
                    amount: amount, 
                    date: _datePicked!, 
                    category: _category!
                  ));
                  Navigator.pop(context);
                }, 
                child: const Text('Save Expense'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: const Text('Cancel')
                )
            ],
          )
        ],),
      );  
  }
}