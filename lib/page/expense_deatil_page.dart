import 'package:flutter/material.dart';
import 'package:hive_practise/page/monthly_summary.dart';
import 'package:hive_practise/page/yearly_summary.dart';

class ExpenseSummaryPage extends StatelessWidget {
  const ExpenseSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Expense Summary"),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Monthly"),
              Tab(text: "Yearly"),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TabBarView(
            children: [
              MonthlySummaryPage(),
              YearlySummaryPage(),
            ],
          ),
        ),
      ),
    );
  }
}
