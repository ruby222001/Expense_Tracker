import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController{
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  String selectedTag = 'Food';
  DateTime selectedDate = DateTime.now();

  final List<String> tags = ['Food', 'Travel', 'Shopping', 'Other'];
}