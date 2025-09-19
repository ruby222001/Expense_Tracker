import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_practise/components/income_expense.dart';
import 'package:hive_practise/controller/app_controller.dart';
import 'package:hive_practise/page/add_expense.dart';
import 'package:hive_practise/page/expense_tile.dart';
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
      bottomNavigationBar: BottomAppBar(
        child: Obx(
          () => SummaryTile(
            icon: Icons.arrow_downward,
            iconColor: Colors.red,
            iconBackground: Colors.green,
            title: 'EXPENSE',
            textColor: Colors.white,
            value: 'Rs ${controller.totalExpense.value.toStringAsFixed(2)}',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => controller.allExpenses.isEmpty
                  ? Center(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No expenses yet"),
                        Image.asset(
                          'assets/images/folder.png',
                          height: 60,
                        )
                      ],
                    ))
                  : ListView.builder(
                      shrinkWrap: false,
                      itemCount: controller.allExpenses.length,
                      itemBuilder: (context, index) {
                        final item = controller.allExpenses[index];
                        return ExpenseTile(
                          item: item,
                          index: index,
                          onEdit: (item, index) {
                            Get.to(
                              () => AddExpensePage(
                                isEditing: true,
                                existingExpense: item,
                                index: index,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                          onDelete: (index) {
                            controller.deleteAt(index);
                          },
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
