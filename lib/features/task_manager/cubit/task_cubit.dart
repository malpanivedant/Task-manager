import 'dart:async';

import 'package:bt_assessment/core/constant/app_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/task_model.dart';
import 'task_state.dart';
import '../../../core/utils/helper.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskState(tasks: AppConstant.mockTasks));

  final Map<String, Timer> _pendingTimers = {};
  final Map<String, bool> _pendingStates = {}; // temporary UI state

  void addTask(TaskModel task) {
    final updated = [...state.tasks, task];
    emitStatusUpadte(updated);
  }

  void removeTask(String id) {
    final updated = state.tasks.where((t) => t.id != id).toList();
    emitStatusUpadte(updated);
  }

  void toggleCompletion(String id) {
    final updated = state.tasks.map((t) {
      if (t.id == id) return t.toggleComplete();
      return t;
    }).toList();

    emitStatusUpadte(updated);
  }

  void updateTask(TaskModel updatedTask) {
    final updatedList = state.tasks.map((task) {
      if (task.id == updatedTask.id) {
        return updatedTask; // replace updated task
      }
      return task; // keep others unchanged
    }).toList();

    emitStatusUpadte(updatedList);
  }

  bool getTemporaryCompletion(String taskId, bool actualState) {
    return _pendingStates.containsKey(taskId)
        ? _pendingStates[taskId]!
        : actualState;
  }

  void toggleCompletionDelayed(TaskModel task) {
    final id = task.id;

    // If a timer is pending → user tapped again → cancel it & revert UI
    if (_pendingTimers.containsKey(id)) {
      _pendingTimers[id]!.cancel();
      _pendingTimers.remove(id);
      _pendingStates.remove(id);

      emitStatusUpadte(state.tasks);
      return;
    }

    // Set temporary UI state
    _pendingStates[id] = !task.isCompleted;
    emitStatusUpadte(state.tasks);

    // Start 5-second commit timer
    _pendingTimers[id] = Timer(const Duration(seconds: 5), () {
      final updatedList = state.tasks.map((t) {
        if (t.id == id) {
          return t.copyWith(isCompleted: !t.isCompleted);
        }
        return t;
      }).toList();

      // Clean up
      _pendingTimers.remove(id);
      _pendingStates.remove(id);
      emitStatusUpadte(updatedList);
    });
  }

  void clearTasks() {
    emit(const TaskState(tasks: []));
  }

  void deleteAllCompleted() {
    final remainingTasks = state.tasks.where((t) => !t.isCompleted).toList();
    emitStatusUpadte(remainingTasks);
  }

  emitStatusUpadte(List<TaskModel> updatedList) {
    emit(state.copyWith(tasks: AppHelper.sortTasks(updatedList)));
  }
}
