import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color backgroundColor;
  final Color iconBackground;

  final Color textColor;

  const SummaryTile({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.backgroundColor = Colors.white,
    this.iconBackground = Colors.white,
    this.textColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: iconBackground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
