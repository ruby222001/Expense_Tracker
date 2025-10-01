import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_practise/controller/app_controller.dart';

class MonthlySummaryPage extends StatelessWidget {
  final controller = Get.find<AppController>();
  final RxSet<String> expandedMonths = <String>{}.obs;

  /// Currently selected year
  final RxString selectedYear = DateTime.now().year.toString().obs;

  MonthlySummaryPage({super.key});
  IconData _getTagIcon(String? tag) {
    switch (tag) {
      case 'Food':
        return Icons.restaurant;
      case 'Travel':
        return Icons.flight;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Other':
      default:
        return Icons.category;
    }
  }

  Color _getTagColor(String? tag) {
    switch (tag) {
      case 'Food':
        return Colors.orange;
      case 'Travel':
        return Colors.blue;
      case 'Shopping':
        return Colors.purple;
      case 'Other':
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allExpenses.isEmpty) {
        return const Center(child: Text("No expense data yet"));
      }

      /// Get list of available years from expenses
      final availableYears = controller.expensesByYear.keys.toList();

      /// Filter months of the selected year
      final expensesThisYear = Map.fromEntries(controller
          .expensesByMonth.entries
          .where((e) => e.key.endsWith(selectedYear.value)));

      return ListView(
        children: [
          const SizedBox(height: 10),

          /// Year Picker Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  "Select Year: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedYear.value,
                  items: availableYears.map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (year) {
                    if (year != null) selectedYear.value = year;
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          /// Monthly Bar Chart
          if (expensesThisYear.isNotEmpty)
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          String formatted;
                          if (value >= 1000) {
                            formatted = "${(value / 1000).toStringAsFixed(0)}k";
                          } else {
                            formatted = value.toInt().toString();
                          }
                          return Text(
                            formatted,
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final months = expensesThisYear.keys.toList();
                          if (value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()].substring(0, 3),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: expensesThisYear.entries
                      .toList()
                      .asMap()
                      .entries
                      .map(
                        (e) => BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: e.value.value,
                              color: Colors.blue,
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text("No monthly data for this year"),
              ),
            ),

          const Divider(),

          /// Expanded Month Details
          ...expensesThisYear.entries.map((entry) {
            final monthKey = entry.key;
            final total = entry.value;
            final shortMonth = monthKey.split(" ")[0].substring(0, 3);
            return Card(
              margin: const EdgeInsets.all(8),
              child: ExpansionTile(
                title: Text(
                  "$shortMonth → Rs ${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  ...controller.getExpensesForMonth(monthKey).map((item) {
                    // Filter by selected year
                    final date = item['date']?.toDate();
                    if (date == null ||
                        date.year.toString() != selectedYear.value) {
                      return const SizedBox.shrink();
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getTagColor(item['tag']),
                        child: Icon(
                          _getTagIcon(item['tag']),
                          color: Colors.white,
                        ),
                      ),
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
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        ],
      );
    });
  }
}
