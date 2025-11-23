import 'package:flutter/material.dart';

class CustomSummaryRow extends StatelessWidget {
  final int total;
  final int completed;
  final int pending;
  final int overdue;
  final int today;

  const CustomSummaryRow({
    super.key,
    required this.total,
    required this.completed,
    required this.pending,
    required this.overdue,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _metricBox("Total", total, const Color.fromARGB(255, 153, 127, 200)),
          _metricBox(
              "Completed", completed, const Color.fromARGB(255, 125, 218, 129)),
          _metricBox(
              "Pending", pending, const Color.fromARGB(255, 105, 164, 191)),
          _metricBox(
              "Overdue", overdue, const Color.fromARGB(255, 216, 108, 100)),
          _metricBox("Today", today, const Color.fromARGB(255, 216, 193, 121)),
        ],
      ),
    );
  }

  Widget _metricBox(String label, int value, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
