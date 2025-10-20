import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_practise/controller/app_controller.dart';
import 'package:hive_practise/page/add_expense.dart';
import 'package:hive_practise/page/expense_deatil_page.dart';
import 'package:hive_practise/page/expense_tile.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final controller = Get.put(AppController());
  final ImagePicker picker = ImagePicker();

  // Future<void> scanReceipt(BuildContext context) async {
  //   final status = await Permission.photos.request();
  //   if (!status.isGranted) return;

  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (pickedFile == null) return;

  //   final imageFile = File(pickedFile.path);
  //   final inputImage = InputImage.fromFile(imageFile);

  //   final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  //   final recognizedText = await textRecognizer.processImage(inputImage);
  //   final scannedText = recognizedText.text;

  //   print("Scanned OCR Text:\n$scannedText");

  //   // --- Extract numbers with currency symbols ---
  //   // This regex captures optional currency symbols before numbers
  //   final currencyRegEx =
  //       RegExp(r'(Rs|INR|\$)?\s*(\d+(\.\d+)?)', caseSensitive: false);
  //   final matches = currencyRegEx.allMatches(scannedText);

  //   List<Map<String, dynamic>> extracted = [];
  //   for (final m in matches) {
  //     final symbol = m.group(1) ?? '';
  //     final value = double.tryParse(m.group(2) ?? '0') ?? 0;
  //     extracted.add({'symbol': symbol, 'value': value});
  //   }

  //   print('Extracted amounts: $extracted');

  //   // Heuristic: total is the largest number
  //   double total = extracted.isNotEmpty
  //       ? extracted
  //           .map((e) => e['value'] as double)
  //           .reduce((a, b) => a > b ? a : b)
  //       : 0;

  //   // Extract date
  //   final dateRegEx =
  //       RegExp(r'(\d{2}[-/]\d{2}[-/]\d{4})|(\d{4}[-/]\d{2}[-/]\d{2})');
  //   DateTime? finalDate;
  //   final dateMatch = dateRegEx.firstMatch(scannedText);
  //   if (dateMatch != null) {
  //     try {
  //       final matchedString = dateMatch.group(0)!;
  //       finalDate = DateFormat('dd-MM-yyyy').parseLoose(matchedString);
  //     } catch (_) {
  //       try {
  //         finalDate = DateFormat('yyyy-MM-dd').parseLoose(dateMatch.group(0)!);
  //       } catch (_) {}
  //     }
  //   }
  //   finalDate ??= DateTime.now();

  //   print("Final Total = $total");
  //   print("Final Date = $finalDate");

  //   Get.to(() => AddExpensePage(
  //         prefilledExpense: "Scanned Receipt",
  //         prefilledPrice: total,
  //         prefilledDate: finalDate,
  //         prefilledTag: "Other",
  //       ));

  //   // Dispose recognizer
  //   textRecognizer.close();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Xpenser",
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
        onPressed: () async {
          Get.to(() => AddExpensePage(), transition: Transition.rightToLeft);

          controller.loadExpenses(); // Refresh on return
        },
        child: Icon(Icons.add),
      ),
      //      SpeedDial(
      // icon: Icons.add,
      // activeIcon: Icons.close,
      // backgroundColor: Colors.white,
      // foregroundColor: Colors.black,
      // overlayOpacity: 0.0, // optional, no overlay
      // spacing: 10,
      // spaceBetweenChildren: 10,
      // children: [
      //   SpeedDialChild(
      //     child: const Icon(Icons.document_scanner, color: Colors.red),
      //     backgroundColor: Colors.white,
      //     label: 'Scan Receipt',
      //     onTap: () async => await scanReceipt(context),
      //   ),
      //   SpeedDialChild(
      //     child: const Icon(Icons.add, color: Colors.black),
      //     backgroundColor: Colors.white,
      //     label: 'Add Expense',
      //     onTap: () async {
      //       await Get.to(() => AddExpensePage(),
      //           transition: Transition.rightToLeft);
      //       controller.loadExpenses();
      //     },
      //   ),

      //   ],
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: GestureDetector(
          onTap: () {
            controller.showInterstitialAd();
          },
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
            child: GestureDetector(
              onTap: () {
                controller.showInterstitialAd();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => controller.isBannerLoaded.value
                        ? Container(
                            width: controller.bannerAd.size.width.toDouble(),
                            height: controller.bannerAd.size.height.toDouble(),
                            child: AdWidget(ad: controller.bannerAd),
                          )
                        : SizedBox(),
                  ),
                  if (controller.expensesByCategoryThisYear.isNotEmpty)
                    const Text(
                      'Pie Chart',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                          legendTextStyle:
                              TextStyle(fontWeight: FontWeight.bold),
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
            ),
          );
        }),
      ),
    );
  }
}
