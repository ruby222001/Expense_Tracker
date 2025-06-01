import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_practise/components/income_expense.dart';
import 'package:hive_practise/controller/app_controller.dart';
import 'package:hive_practise/page/add_expense.dart';
import 'package:hive_practise/theme/settings.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final controller = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, Ruby"),
        actions: [
          // GestureDetector(
          //     onTap: () {
          //       Get.to(() => Settings());
          //     },
          //     child: Icon(Icons.settings)),
          GestureDetector(
              onTap: () {
                // Get.to(() => Settings());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.person),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.to(() => AddExpensePage(), transition: Transition.rightToLeft);

          controller.loadExpenses(); // Refresh on return
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Obx(
            () => SummaryTile(
              icon: Icons.arrow_downward,
              iconColor: Colors.red,
              iconBackground: Colors.red.shade100,
              title: 'EXPENSE',
              textColor: Colors.black,
              value: 'Rs ${controller.totalExpense.value.toStringAsFixed(2)}',
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.allExpenses.isEmpty
                  ? Center(child: Text("No expenses yet"))
                  : ListView.builder(
                      shrinkWrap: false,
                      itemCount: controller.allExpenses.length,
                      itemBuilder: (context, index) {
                        final item = controller.allExpenses[index];
                        return Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Expense & Price display
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['expense'] ?? '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text('Rs. ${item['price'] ?? ''}',
                                      style: TextStyle(fontSize: 14)),
                                  Text('Tag: ${item['tag'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  Text('Date: ${item['date'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),

                              // Buttons: Update and Delete
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.green),
                                    onPressed: () {
                                      Get.to(
                                          () => AddExpensePage(
                                              isEditing: true,
                                              existingExpense: item,
                                              index: index),
                                          transition: Transition.rightToLeft);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      controller.deleteAt(index);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
