import 'package:auto_route/auto_route.dart';
import 'package:bt_assessment/core/widgets/custom_button.dart';
import 'package:bt_assessment/core/widgets/custom_input_text_widget.dart';
import 'package:bt_assessment/core/widgets/custom_task_tile.dart';
import 'package:bt_assessment/features/task_manager/cubit/task_cubit.dart';
import 'package:bt_assessment/features/task_manager/cubit/task_state.dart';
import 'package:bt_assessment/features/task_manager/model/task_model.dart';
import 'package:bt_assessment/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'delete_completed') {
                context.read<TaskCubit>().deleteAllCompleted();
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete_completed',
                child: Text("Delete All Completed Tasks"),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => context.router.push(AddTaskRoute()),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// SEARCH BAR
            CustomInputTextWidget(
              controller: _searchController,
              label: "Search Tasks",
              hint: "Search by title...",
              isSearch: true,
              suffixIcon: Icons.close,
              onSuffixTap: () {
                _searchController.clear();
                setState(() {});
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            /// TASK LIST
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  final tasks = state.tasks;

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text(
                        "No task available",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  /// Apply search filter
                  final filtered = tasks.where((task) {
                    final query = _searchController.text.trim().toLowerCase();
                    return task.title.toLowerCase().contains(query) ||
                        task.description.toLowerCase().contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text("No matching tasks found"),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final task = filtered[index];

                      return _buildTaskItem(context, task);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 54,
        child: CustomButton(
          title: "View Report",
          isCurved: false,
          onPressed: () => context.router.push(const ReportRoute()),
        ),
      ),
    );
  }

  /// TASK ITEM UI
  Widget _buildTaskItem(BuildContext context, TaskModel task) {
    return RepaintBoundary(
      child: Dismissible(
        key: ValueKey(task.id),

        direction: DismissDirection.endToStart, // swipe left to delete
        background: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 239, 181, 177),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ),

        onDismissed: (_) {
          context.read<TaskCubit>().removeTask(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${task.title} deleted")),
          );
        },

        child: CustomTaskTile(task: task),
      ),
    );
  }
}
