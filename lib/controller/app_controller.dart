import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_practise/components/snackbar.dart';

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

  void loadExpenses() {
    final savedList = box.get('expensesList');
    if (savedList != null) {
      allExpenses.value = List<Map<String, String>>.from(
          (savedList as List).map((e) => Map<String, String>.from(e)));
      calculateTotalExpense();
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
    SSnackbarUtil.showFadeSnackbar(
        context, "added expense", SnackbarType.success);
    print("Added: $newEntry");
  }

  void deleteAt(int index) {
    if (index >= 0 && index < allExpenses.length) {
      final removed = allExpenses.removeAt(index);
      box.put('expensesList', allExpenses);
      calculateTotalExpense();
      print("Deleted item at $index: $removed");
    }
  }

  void updateAt(BuildContext context, int index, String newExpense,
      String newPrice, String newTag, String newDate) {
    if (index >= 0 && index < allExpenses.length) {
      allExpenses[index] = {
        'expense': newExpense,
        'price': newPrice,
        'tag': newTag,
        'date': newDate,
      };
      box.put('expensesList', allExpenses);
      calculateTotalExpense();
      SSnackbarUtil.showFadeSnackbar(
          context, "updated expense", SnackbarType.success);

      print("Updated item at $index: ${allExpenses[index]}");
    }
  }
}
