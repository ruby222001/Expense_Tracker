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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          Get.to(() => AddExpensePage(), transition: Transition.rightToLeft);

          controller.loadExpenses(); // Refresh on return
        },
        child: Icon(
          Icons.add,
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!controller.expensesByCategory.isEmpty)
              Text('Pie Chart',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            // Inside body:
            Obx(() {
              if (controller.expensesByCategory.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox.shrink(),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: PieChart(
                  dataMap: controller.expensesByCategory,
                  animationDuration: Duration(milliseconds: 800),
                  chartRadius: MediaQuery.of(context).size.width / 2.2,
                  chartType: ChartType.disc,
                  legendOptions: LegendOptions(
                    legendPosition: LegendPosition.right,
                    showLegendsInRow: false,
                    legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    decimalPlaces: 1,
                  ),
                ),
              );
            }),

            Expanded(
              child: Obx(
                () => controller.allExpenses.isEmpty
                    ? Center(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/folder.png',
                            height: 60,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("No expenses yet"),
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
      ),
    );
  }
}
