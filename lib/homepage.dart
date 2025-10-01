import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_practise/components/income_expense.dart';
import 'package:hive_practise/controller/app_controller.dart';
import 'package:hive_practise/page/add_expense.dart';
import 'package:hive_practise/page/expense_deatil_page.dart';
import 'package:hive_practise/page/expense_tile.dart';
import 'package:hive_practise/theme/settings.dart';
import 'package:pie_chart/pie_chart.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final controller = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // GestureDetector(
          //     onTap: () {
          //       Get.to(() => Settings());
          //     },
          //     child: Icon(Icons.settings)),
          GestureDetector(
              onTap: () {
                Get.to(() => ExpenseSummaryPage());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.summarize),
              )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white, // matches bottom bar
        elevation: 6,
        onPressed: () async {
          await Get.to(() => AddExpensePage(),
              transition: Transition.rightToLeft);
          controller.loadExpenses(); // Refresh on return
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Obx(
            () => Row(
              children: [
                const Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Expense',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Rs ${controller.totalExpenseThisYear.value.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.allExpenses.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/folder.png',
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text("No expenses yet"),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.expensesByCategoryThisYear.isNotEmpty)
                  const Text(
                    'Pie Chart',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                /// Pie chart
                if (controller.expensesByCategoryThisYear.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: PieChart(
                      dataMap: controller.expensesByCategoryThisYear,
                      animationDuration: const Duration(milliseconds: 800),
                      chartRadius: MediaQuery.of(context).size.width / 2.2,
                      chartType: ChartType.disc,
                      legendOptions: const LegendOptions(
                        legendPosition: LegendPosition.right,
                        showLegendsInRow: false,
                        legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),

                /// Expense list
                ListView.builder(
                  shrinkWrap: true, // ✅ Important
                  physics:
                      const NeverScrollableScrollPhysics(), // ✅ disable inner scroll
                  itemCount: controller.expensesThisYear.length,
                  itemBuilder: (context, index) {
                    final item = controller.expensesThisYear[index];

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
              ],
            ),
          );
        }),
      ),
    );
  }
}
