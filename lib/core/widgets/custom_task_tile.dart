import 'package:auto_route/auto_route.dart';
import 'package:bt_assessment/core/widgets/custom_task_banner.dart';
import 'package:bt_assessment/features/task_manager/cubit/task_cubit.dart';
import 'package:bt_assessment/features/task_manager/model/task_model.dart';
import 'package:bt_assessment/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTaskTile extends StatelessWidget {
  final TaskModel task;
  const CustomTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: task.isCompleted ? 0.45 : 1.0, // 👈 Faded when completed
      child: Stack(
        children: [
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ListTile(
                onTap: () => context.router
                    .push(AddTaskRoute(task: task, isEditing: true)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),

                /// Checkbox
                leading: Checkbox(
                  value: context.read<TaskCubit>().getTemporaryCompletion(
                        task.id,
                        task.isCompleted,
                      ),
                  onChanged: (_) {
                    context.read<TaskCubit>().toggleCompletionDelayed(task);
                  },
                ),

                /// Title (NO STRIKE THROUGH NOW)
                title: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                /// Description + due date
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Due: ${task.dueDate.toString().split(' ')[0]}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),

                trailing: Icon(
                  Icons.circle,
                  color: task.priorityValue,
                  size: 24,
                ),
              ),
            ),
          ),

          /// Banner (Today/Overdue)
          if (!task.isCompleted) CustomTaskBanner(dueDate: task.dueDate),
        ],
      ),
    );
  }
}
