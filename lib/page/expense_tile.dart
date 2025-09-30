import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final void Function(int index) onDelete;
  final void Function(Map<String, dynamic>? item, int index) onEdit;

  const ExpenseTile({
    super.key,
    required this.item,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  });

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
    final tag = item['tag'] ?? 'Other';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
      padding: const EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 3,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon based on tag
          CircleAvatar(
            backgroundColor: _getTagColor(tag),
            child: Icon(
              _getTagIcon(tag),
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          // Expense Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['expense'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${item['price'] ?? ''}',
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
                const SizedBox(height: 2),
                Text(
                  'Date: ${item['date'] ?? ''}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          // Popup Menu Button
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEdit(item, index);
              } else if (value == 'delete') {
                onDelete(index);
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
