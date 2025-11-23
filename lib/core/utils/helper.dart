import 'package:bt_assessment/core/widgets/custom_task_banner.dart';
import 'package:bt_assessment/features/task_manager/model/task_model.dart';
import 'package:flutter/material.dart';

class AppHelper {
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isOverdue(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    return target.isBefore(today);
  }

  static DueDateType getDueDateType(DateTime? dueDate) {
    if (dueDate == null) return DueDateType.noDate;
    if (isToday(dueDate)) return DueDateType.today;
    if (isOverdue(dueDate)) return DueDateType.overdue;
    return DueDateType.onTime;
  }

  static Color getPriorityColor(PriorityOrder priority) {
    switch (priority) {
      case PriorityOrder.p1:
        return Colors.red;
      case PriorityOrder.p2:
        return Colors.amber;
      case PriorityOrder.p3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static String? required(String? v, String field) {
    if (v == null || v.trim().isEmpty) return "Enter $field";
    return null;
  }

  static List<TaskModel> sortTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    bool isOverdue(TaskModel task) =>
        !task.isCompleted &&
        task.dueDate != null &&
        task.dueDate!.isBefore(today);

    bool isToday(TaskModel task) =>
        !task.isCompleted &&
        task.dueDate != null &&
        AppHelper.getDueDateType(task.dueDate) == DueDateType.today;

    bool isCompleted(TaskModel task) => task.isCompleted;

    bool isRemaining(TaskModel task) =>
        !task.isCompleted && !isOverdue(task) && !isToday(task);

    final overdue = tasks.where(isOverdue).toList();
    final todayList = tasks.where(isToday).toList();
    final remaining = tasks.where(isRemaining).toList();
    final completed = tasks.where(isCompleted).toList();

    // Sort by creation time (newest first)
    int byCreated(TaskModel a, TaskModel b) =>
        b.creationTime.compareTo(a.creationTime);

    overdue.sort(byCreated);
    todayList.sort(byCreated);
    remaining.sort(byCreated);
    completed.sort(byCreated);

    return [
      ...overdue,
      ...todayList,
      ...remaining,
      ...completed,
    ];
  }
}
