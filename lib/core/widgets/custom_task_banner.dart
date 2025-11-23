import 'package:bt_assessment/core/utils/helper.dart';
import 'package:flutter/material.dart';

enum DueDateType { noDate, today, overdue, onTime }

class CustomTaskBanner extends StatelessWidget {
  final DateTime? dueDate;
  const CustomTaskBanner({super.key, this.dueDate});

  @override
  Widget build(BuildContext context) {
    final type = AppHelper.getDueDateType(dueDate);

    // Nothing to show
    if (type == DueDateType.noDate || type == DueDateType.onTime) {
      return const SizedBox.shrink();
    }

    // Lite banner builder
    Widget buildBanner(String text, Color color) {
      return Positioned(
        top: 2,
        left: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    switch (type) {
      case DueDateType.today:
        return buildBanner(
          "Due Today",
          const Color.fromARGB(255, 246, 238, 163),
        );

      case DueDateType.overdue:
        return buildBanner(
          "Overdue",
          const Color.fromARGB(255, 249, 188, 183),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
