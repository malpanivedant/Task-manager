import 'package:bt_assessment/features/task_manager/model/task_model.dart';

class AppConstant {
  static final mockTasks = [
    TaskModel(
      id: "1",
      title: "Prepare project report",
      description: "Write summary for the quarterly performance review.",
      priorityOrder: PriorityOrder.p1,
      creationTime: DateTime.now().subtract(const Duration(days: 3)),
      dueDate: DateTime.now().subtract(const Duration(days: 1)), // OVERDUE
      isCompleted: false,
    ),
    TaskModel(
      id: "7",
      title: "Send email updates",
      description: "Weekly update mail to the product team.",
      priorityOrder: PriorityOrder.p2,
      creationTime: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)), // OVERDUE
      isCompleted: false,
    ),
    TaskModel(
      id: "2",
      title: "Buy groceries",
      description: "Milk, vegetables, bread, and eggs.",
      priorityOrder: PriorityOrder.p3,
      creationTime: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now(), // TODAY
      isCompleted: false,
    ),
    TaskModel(
      id: "3",
      title: "Team meeting",
      description: "Discuss next sprint planning and allocations.",
      priorityOrder: PriorityOrder.p2,
      creationTime: DateTime.now().subtract(const Duration(days: 7)),
      dueDate: DateTime.now().add(const Duration(days: 2)), // UPCOMING
      isCompleted: false,
    ),
    TaskModel(
      id: "4",
      title: "Submit expense bills",
      description: "Upload all receipts to finance portal.",
      priorityOrder: PriorityOrder.p1,
      creationTime: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isCompleted: false,
    ),
    TaskModel(
      id: "5",
      title: "Workout session",
      description: "45 minutes cardio + core strengthening.",
      priorityOrder: PriorityOrder.p2,
      creationTime: DateTime.now(),
      dueDate: null, // NO DATE
      isCompleted: false,
    ),
    TaskModel(
      id: "6",
      title: "Read Flutter docs",
      description: "Immerse in state management and animations chapter.",
      priorityOrder: PriorityOrder.p3,
      creationTime: DateTime.now().subtract(const Duration(days: 4)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: true, // COMPLETED
      completedTime: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
