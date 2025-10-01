import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_practise/controller/app_controller.dart';

class YearlySummaryPage extends StatelessWidget {
  final controller = Get.find<AppController>();

  YearlySummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allExpenses.isEmpty) {
        return const Center(child: Text("No expense data yet"));
      }

      return ListView(
        children: [
          const SizedBox(height: 10),

          /// Yearly Bar Chart
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
                        final years = controller.expensesByYear.keys.toList();
                        if (value.toInt() < years.length) {
                          return Text(
                            years[value.toInt()],
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
                barGroups: controller.expensesByYear.entries
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.value,
                            color: Colors.green,
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          const Divider(),
          ...controller.expensesByYear.entries.map((entry) {
            return ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: Text("Year ${entry.key}"),
              trailing: Text("Rs ${entry.value.toStringAsFixed(2)}"),
            );
          }).toList(),
        ],
      );
    });
  }
}
