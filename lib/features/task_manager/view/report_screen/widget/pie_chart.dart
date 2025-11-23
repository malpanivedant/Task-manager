import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CustomReportPieChart extends StatelessWidget {
  final int completed;
  final int pending;
  final int overdue;
  final int dueToday;

  const CustomReportPieChart({
    super.key,
    required this.completed,
    required this.pending,
    required this.overdue,
    required this.dueToday,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PieChart(
        dataMap: {
          "Completed": completed.toDouble(),
          "Pending": (pending - overdue - dueToday)
              .toDouble()
              .clamp(0, double.infinity),
          "Due Today": dueToday.toDouble(),
          "Overdue": overdue.toDouble(),
        },
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 24,
        chartRadius: MediaQuery.of(context).size.width / 2.6,
        colorList: const [
          Color.fromARGB(255, 187, 221, 188),
          Color.fromARGB(255, 170, 189, 198),
          Color.fromARGB(255, 232, 220, 184),
          Color.fromARGB(255, 220, 189, 187),
        ],
        chartType: ChartType.disc,
        legendOptions: const LegendOptions(
          legendPosition: LegendPosition.right,
          showLegendsInRow: false,
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValues: true,
          showChartValueBackground: false,
        ),
      ),
    );
  }
}
