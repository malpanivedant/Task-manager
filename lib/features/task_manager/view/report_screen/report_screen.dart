import 'package:auto_route/auto_route.dart';
import 'package:bt_assessment/core/utils/helper.dart';
import 'package:bt_assessment/features/task_manager/view/report_screen/widget/pie_chart.dart';
import 'package:bt_assessment/features/task_manager/view/report_screen/widget/summary_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/task_cubit.dart';
import '../../cubit/task_state.dart';
import '../../model/task_model.dart';
import '../../../../core/widgets/custom_task_tile.dart';

@RoutePage()
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Task Report"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            BlocBuilder<TaskCubit, TaskState>(
              buildWhen: (prev, curr) => prev.tasks != curr.tasks,
              builder: (context, state) {
                final tasks = state.tasks;

                final total = tasks.length;
                final completed = tasks.where((t) => t.isCompleted).length;
                final pending = tasks.where((t) => !t.isCompleted).length;

                final overdue = tasks.where((t) {
                  if (t.isCompleted) return false;
                  if (t.dueDate == null) return false;
                  return AppHelper.isOverdue(t.dueDate!);
                }).length;

                final dueToday = tasks.where((t) {
                  if (t.isCompleted) return false;
                  if (t.dueDate == null) return false;
                  return AppHelper.isToday(t.dueDate!);
                }).length;

                return Column(
                  children: [
                    RepaintBoundary(
                      child: CustomReportPieChart(
                        completed: completed,
                        pending: pending,
                        overdue: overdue,
                        dueToday: dueToday,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RepaintBoundary(
                      child: CustomSummaryRow(
                        total: total,
                        completed: completed,
                        pending: pending,
                        overdue: overdue,
                        today: dueToday,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(
                        thickness: 1,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Task List",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
            const TabBar(
              isScrollable: false,
              tabs: [
                Tab(text: "All"),
                Tab(text: "Pending"),
                Tab(text: "Completed"),
                Tab(text: "Completed\nToday"),
              ],
            ),
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                buildWhen: (prev, curr) => prev.tasks != curr.tasks,
                builder: (context, state) {
                  final tasks = state.tasks;

                  final completedToday = tasks.where((t) {
                    if (!t.isCompleted) return false;
                    return t.completedTime != null &&
                        AppHelper.isToday(t.completedTime!);
                  }).toList();

                  return TabBarView(
                    children: [
                      _taskList(tasks),
                      _taskList(tasks.where((t) => !t.isCompleted).toList()),
                      _taskList(tasks.where((t) => t.isCompleted).toList()),
                      _taskList(completedToday),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---- LIST BUILDER (Optimized)
  Widget _taskList(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks available"));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: CustomTaskTile(task: tasks[index]),
        );
      },
    );
  }
}
