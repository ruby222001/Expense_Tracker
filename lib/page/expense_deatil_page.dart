import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:hive_practise/controller/app_controller.dart';

class ExpenseSummaryPage extends StatefulWidget {
  const ExpenseSummaryPage({super.key});

  @override
  State<ExpenseSummaryPage> createState() => _ExpenseSummaryPageState();
}

class _ExpenseSummaryPageState extends State<ExpenseSummaryPage> {
  final controller = Get.find<AppController>();
  final RxSet<String> expandedMonths = <String>{}.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Summary")),
      body: Obx(() {
        if (controller.allExpenses.isEmpty) {
          return const Center(child: Text("No expense data yet"));
        }

        return ContainedTabBarView(
          tabs: const [
            Text("Monthly"),
            Text("Yearly"),
          ],
          tabBarProperties: TabBarProperties(
              indicatorColor: Colors.blue,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              )
              // background:
              ),
          views: [
            /// ---------------- Monthly Summary ----------------
            ListView(
              children: [
                const SizedBox(height: 10),
                ...controller.expensesByMonth.entries.map((entry) {
                  final monthKey = entry.key;
                  final total = entry.value;
                  final isExpanded = expandedMonths.contains(monthKey);

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Text(
                        "$monthKey → Rs ${total.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (expanded) {
                        if (expanded) {
                          expandedMonths.add(monthKey);
                        } else {
                          expandedMonths.remove(monthKey);
                        }
                      },
                      children: [
                        ...controller.getExpensesForMonth(monthKey).map((item) {
                          return ListTile(
                            title: Text(item['expense'] ?? ""),
                            subtitle: Text(
                              "Tag: ${item['tag']} | Date: ${item['date']}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Text(
                              "Rs ${item['price']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),

            /// ---------------- Yearly Summary ----------------
            ListView(
              children: [
                const SizedBox(height: 10),
                ...controller.expensesByYear.entries.map((entry) {
                  return ListTile(
                    leading:
                        const Icon(Icons.calendar_today, color: Colors.blue),
                    title: Text("Year ${entry.key}"),
                    trailing: Text("Rs ${entry.value.toStringAsFixed(2)}"),
                  );
                }).toList(),
              ],
            ),
          ],
        );
      }),
    );
  }
}
