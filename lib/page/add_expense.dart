import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_practise/components/snackbar.dart';
import 'package:hive_practise/page/add_expense_controller.dart';
import 'package:intl/intl.dart';
import 'package:hive_practise/controller/app_controller.dart';

class AddExpensePage extends StatefulWidget {
  final bool isEditing;
  final int? index;
  final Map<String, dynamic>? existingExpense;

  AddExpensePage({this.isEditing = false, this.index, this.existingExpense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final controller = Get.find<AppController>();
  final addExpensecontroller = Get.put(ExpenseController());
  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.existingExpense != null) {
      addExpensecontroller.expenseController.text =
          widget.existingExpense!['expense'] ?? '';
      addExpensecontroller.priceController.text =
          widget.existingExpense!['price'] ?? '';
      addExpensecontroller.selectedTag =
          widget.existingExpense!['tag'] ?? addExpensecontroller.tags.first;
      addExpensecontroller.selectedDate = DateFormat('yyyy-MM-dd')
          .parse(widget.existingExpense!['date'] ?? DateTime.now().toString());
    }
  }

  @override
  void dispose() {
    addExpensecontroller.expenseController.clear();
    addExpensecontroller.priceController.clear();
    addExpensecontroller.selectedTag = 'Food';
    addExpensecontroller.selectedDate = DateTime.now();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: addExpensecontroller.expenseController,
                decoration: InputDecoration(
                  labelText: 'Expense Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: addExpensecontroller.priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Tag Dropdown
              DropdownButtonFormField<String>(
                value: addExpensecontroller.selectedTag,
                items: addExpensecontroller.tags
                    .map((tag) => DropdownMenuItem(
                          value: tag,
                          child: Text(tag),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    addExpensecontroller.selectedTag = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Date Picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today: ${DateFormat('yyyy-MM-dd').format(addExpensecontroller.selectedDate)}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  CalendarDatePicker(
                    initialDate: addExpensecontroller.selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2101),
                    onDateChanged: (date) {
                      setState(() {
                        addExpensecontroller.selectedDate = date;
                      });
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final expense =
                          addExpensecontroller.expenseController.text.trim();
                      final price =
                          addExpensecontroller.priceController.text.trim();
                      final tag = addExpensecontroller.selectedTag;
                      final formattedDate = DateFormat('yyyy-MM-dd')
                          .format(addExpensecontroller.selectedDate);

                      if (expense.isNotEmpty && price.isNotEmpty) {
                        if (widget.isEditing && widget.index != null) {
                          controller.updateAt(context, widget.index!, expense,
                              price, tag, formattedDate);
                        } else {
                          controller.addData(
                              context, expense, price, tag, formattedDate);
                        }
                        Navigator.pop(context);
                      } else {
                        SSnackbarUtil.showFadeSnackbar(
                            context, "add expense to save", SnackbarType.info);
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
