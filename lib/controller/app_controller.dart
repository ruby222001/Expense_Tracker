import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_practise/components/snackbar.dart';
import 'package:intl/intl.dart';

extension DateParsing on String {
  DateTime? toDate() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }
}

class AppController extends GetxController {
  late Box box;
  RxList<Map<String, String>> allExpenses = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    box = Hive.box('test');
    loadExpenses();
  }

// Total expense getter
  RxDouble totalExpense = 0.0.obs;

  void calculateTotalExpense() {
    double total = 0.0;
    for (var item in allExpenses) {
      final price = double.tryParse(item['price'] ?? '0') ?? 0.0;
      total += price;
    }
    totalExpense.value = total;
  }

// Expenses list of current year
  List<Map<String, String>> get expensesThisYear {
    final currentYear = DateTime.now().year;
    return allExpenses.where((item) {
      final date = item['date']?.toDate();
      return date != null && date.year == currentYear;
    }).toList();
  }

// Pie chart data (category) only for current year
  Map<String, double> get expensesByCategoryThisYear {
    Map<String, double> dataMap = {};
    final currentYear = DateTime.now().year;

    for (var item in allExpenses) {
      final date = item['date']?.toDate();
      if (date == null || date.year != currentYear) continue;

      final tag = item['tag'] ?? 'Other';
      final price = double.tryParse(item['price'].toString()) ?? 0;

      if (dataMap.containsKey(tag)) {
        dataMap[tag] = dataMap[tag]! + price;
      } else {
        dataMap[tag] = price;
      }
    }

    return dataMap;
  }

  Map<String, double> get expensesByCategory {
    Map<String, double> dataMap = {};

    for (var item in allExpenses) {
      final tag = item['tag'] ?? 'Other';
      final price = double.tryParse(item['price'].toString()) ?? 0;

      if (dataMap.containsKey(tag)) {
        dataMap[tag] = dataMap[tag]! + price;
      } else {
        dataMap[tag] = price;
      }
    }

    return dataMap;
  }

  /// Group expenses by month for a specific year
  Map<String, double> getExpensesByMonthForYear(String year) {
    Map<String, double> dataMap = {};
    for (var item in allExpenses) {
      final date = item['date']?.toDate();
      final price = double.tryParse(item['price'] ?? '0') ?? 0;
      if (date != null && date.year.toString() == year) {
        String key = DateFormat('MMMM yyyy').format(date);
        dataMap[key] = (dataMap[key] ?? 0) + price;
      }
    }

    // Sort by latest date first
    final sortedEntries = dataMap.entries.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a.key);
        final dateB = DateFormat('MMMM yyyy').parse(b.key);
        return dateB.compareTo(dateA); // newest first
      });

    return Map.fromEntries(sortedEntries);
  }

  /// Get expenses (list) for a specific month in a specific year
  List<Map<String, String>> getExpensesForMonthByYear(
      String year, String monthKey) {
    final parsedDate = DateFormat('MMMM yyyy').parse(monthKey);
    return allExpenses.where((item) {
      final date = item['date']?.toDate();
      if (date == null) return false;
      return (date.month == parsedDate.month && date.year.toString() == year);
    }).toList();
  }

  Map<String, double> get expensesByMonth {
    Map<String, double> dataMap = {};
    for (var item in allExpenses) {
      final date = item['date']?.toDate();
      final price = double.tryParse(item['price'] ?? '0') ?? 0;
      if (date != null) {
        // Format month as "January 2025"
        String key = "${DateFormat('MMMM yyyy').format(date)}";
        dataMap[key] = (dataMap[key] ?? 0) + price;
      }
    }

    // Sort by latest date first
    final sortedEntries = dataMap.entries.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a.key);
        final dateB = DateFormat('MMMM yyyy').parse(b.key);
        return dateB.compareTo(dateA); // newest first
      });

    return Map.fromEntries(sortedEntries);
  }

  Map<String, double> get expensesByYear {
    Map<String, double> dataMap = {};
    for (var item in allExpenses) {
      final date = item['date']?.toDate();
      final price = double.tryParse(item['price'] ?? '0') ?? 0;
      if (date != null) {
        String key = "${date.year}";
        dataMap[key] = (dataMap[key] ?? 0) + price;
      }
    }

    // Sort years newest first
    final sortedEntries = dataMap.entries.toList()
      ..sort((a, b) => int.parse(b.key).compareTo(int.parse(a.key)));

    return Map.fromEntries(sortedEntries);
  }

// Total expense of current year
  RxDouble totalExpenseThisYear = 0.0.obs;

  void calculateTotalExpenseThisYear() {
    double total = 0.0;
    final currentYear = DateTime.now().year;
    for (var item in allExpenses) {
      final date = item['date']?.toDate();
      final price = double.tryParse(item['price'] ?? '0') ?? 0.0;

      if (date != null && date.year == currentYear) {
        total += price;
      }
    }
    totalExpenseThisYear.value = total;
  }

  List<Map<String, String>> getExpensesForMonth(String monthKey) {
    final parsedDate = DateFormat('MMMM yyyy').parse(monthKey);
    return allExpenses.where((item) {
      final date = item['date']?.toDate();
      if (date == null) return false;
      return (date.month == parsedDate.month && date.year == parsedDate.year);
    }).toList();
  }

  void loadExpenses() {
    final savedList = box.get('expensesList');
    if (savedList != null) {
      allExpenses.value = List<Map<String, String>>.from(
          (savedList as List).map((e) => Map<String, String>.from(e)));
      calculateTotalExpense();
      calculateTotalExpenseThisYear(); // ✅
    }
  }

  void deleteAt(int index) {
    if (index >= 0 && index < allExpenses.length) {
      final removed = allExpenses.removeAt(index);
      box.put('expensesList', allExpenses);
      calculateTotalExpense();
      calculateTotalExpenseThisYear(); // ✅
      print("Deleted item at $index: $removed");
    }
  }

  void updateAt(BuildContext context, int index, String newExpense,
      String newPrice, String newTag, String newDate) {
    if (index >= 0 && index < allExpenses.length) {
      // Update the map and refresh the list to notify observers
      allExpenses[index].assignAll({
        'expense': newExpense,
        'price': newPrice,
        'tag': newTag,
        'date': newDate,
      });

      allExpenses.refresh(); // ✅ This ensures UI updates

      box.put('expensesList', allExpenses);
      calculateTotalExpense();
      calculateTotalExpenseThisYear();

      SSnackbarUtil.showFadeSnackbar(
          context, "Updated expense", SnackbarType.success);

      print("Updated item at $index: ${allExpenses[index]}");
    }
  }

  void addData(BuildContext context, String expense, String price, String tag,
      String date) {
    final newEntry = {
      'expense': expense,
      'price': price,
      'tag': tag,
      'date': date,
    };
    allExpenses.add(newEntry);
    box.put('expensesList', allExpenses);
    calculateTotalExpense();
    calculateTotalExpenseThisYear(); // ✅
    SSnackbarUtil.showFadeSnackbar(
        context, "added expense", SnackbarType.success);
    print("Added: $newEntry");
  }
}
