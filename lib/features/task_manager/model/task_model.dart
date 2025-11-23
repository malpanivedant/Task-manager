import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final PriorityOrder priorityOrder;
  final bool isCompleted;
  final DateTime creationTime;
  final DateTime? completedTime;
  final DateTime? dueDate;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.creationTime,
    this.priorityOrder = PriorityOrder.p3,
    this.isCompleted = false,
    this.completedTime,
    this.dueDate,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    PriorityOrder? priorityOrder,
    bool? isCompleted,
    DateTime? creationTime,
    DateTime? completedTime,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priorityOrder: priorityOrder ?? this.priorityOrder,
      isCompleted: isCompleted ?? this.isCompleted,
      creationTime: creationTime ?? this.creationTime,
      completedTime: completedTime ?? this.completedTime,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  TaskModel toggleComplete() {
    return copyWith(
      isCompleted: !isCompleted,
      completedTime: !isCompleted ? DateTime.now() : null,
    );
  }

  Color get priorityValue {
    switch (priorityOrder) {
      case PriorityOrder.p1:
        return Colors.red;
      case PriorityOrder.p2:
        return Colors.yellow;
      case PriorityOrder.p3:
        return Colors.green;
    }
  }
}

enum PriorityOrder { p1, p2, p3 }
