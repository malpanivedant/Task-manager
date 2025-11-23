import '../model/task_model.dart';

class TaskState {
  final List<TaskModel> tasks;

  const TaskState({this.tasks = const []});

  TaskState copyWith({List<TaskModel>? tasks}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
    );
  }
}
