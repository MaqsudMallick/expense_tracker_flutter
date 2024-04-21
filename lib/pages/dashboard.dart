import 'dart:html';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/pages/add_expense_sheet.dart';
import 'package:expense_tracker/pages/chart.dart';
import 'package:flutter/material.dart';
class Dashboard extends StatefulWidget{
  const Dashboard({super.key});
  @override
  State<Dashboard> createState(){
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard>{
  final List<Expense> _dummyExpenseList = [];
  void addExpense(Expense expense){
    setState(() {
      _dummyExpenseList.add(expense);
    });
  }
  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    print(windowWidth);
    Widget expenseListWidget = Expanded(child: ListView.builder(
      itemCount: _dummyExpenseList.length,
      itemBuilder: (ctx, index) { 
        return  Dismissible(
          key: ValueKey(_dummyExpenseList[index]),
          onDismissed: (DismissDirection dtx) {
            final i = index;
            final e = _dummyExpenseList[i];
            setState(() {
              _dummyExpenseList.remove(e);
            });
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Expense deleted'),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(label: 'Undo', onPressed: () {
                  setState(() {
                    _dummyExpenseList.insert(i, e);
                  });
                }), 
              )
            );
          }, 
          child: Card(
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Column(
              children: [
                Text(_dummyExpenseList[index].title),
                const SizedBox(height: 10,),
                Row(
                  children: [
                  Text(_dummyExpenseList[index].amount.toStringAsFixed(2)),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(categoryLogos[_dummyExpenseList[index].category]),
                      const SizedBox(width: 5,),
                      Text(_dummyExpenseList[index].formattedDate)
                    ],
                  )
                  ]
                )
              ],
            ),
            )   
          ),
        );    
    }));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true, 
              context: context, 
              useSafeArea: true,
              builder: (ctx) => SizedBox(
                width: double.infinity,
                child: AddExpenseSheet(addExpense)
                ));
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: _dummyExpenseList.isEmpty? const Center(
            child: Text('No expenses found. Try adding some.'),
      ) 
      :
       windowWidth<600 ? Column(
        children: [
          Chart(expenses: _dummyExpenseList),
          expenseListWidget         
        ],
      ): 
      Row(
        children: [
          Expanded(
           child: Chart(expenses: _dummyExpenseList),  
          ),
          expenseListWidget  
        ],
      ),
      
    );
    
  }
}