import 'package:auto_route/auto_route.dart';
import 'package:bt_assessment/core/utils/helper.dart';
import 'package:bt_assessment/core/widgets/custom_button.dart';
import 'package:bt_assessment/core/widgets/custom_dropdown.dart';
import 'package:bt_assessment/core/widgets/custom_input_text_widget.dart';
import 'package:bt_assessment/features/task_manager/cubit/task_cubit.dart';
import 'package:bt_assessment/features/task_manager/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;
  final bool isEditing;

  const AddTaskScreen({
    super.key,
    this.task,
    this.isEditing = false,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  PriorityOrder? selectedPriority; // Nullable now
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.isEditing ? widget.task?.title : "",
    );

    _descriptionController = TextEditingController(
      text: widget.isEditing ? widget.task?.description : "",
    );

    if (widget.isEditing && widget.task != null) {
      selectedPriority = widget.task!.priorityOrder;
      dueDate = widget.task!.dueDate;
    } else {
      selectedPriority = null;
    }
  }

  void _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.isEditing && widget.task != null) {
      final updatedTask = widget.task!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priorityOrder: selectedPriority ?? widget.task!.priorityOrder,
        dueDate: dueDate,
      );

      context.read<TaskCubit>().updateTask(updatedTask);
    } else {
      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        creationTime: DateTime.now(),
        priorityOrder: selectedPriority ?? PriorityOrder.p3, // fallback
        dueDate: dueDate,
      );
      context.read<TaskCubit>().addTask(newTask);
    }

    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Task" : "Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              /// TITLE
              CustomInputTextWidget(
                label: "Title",
                controller: _titleController,
                validator: (v) => AppHelper.required(v, "title"),
              ),
              const SizedBox(height: 16),

              /// DESCRIPTION
              CustomInputTextWidget(
                label: "Description",
                controller: _descriptionController,
                validator: (v) => AppHelper.required(v, "description"),
              ),
              const SizedBox(height: 20),

              /// PRIORITY DROPDOWN
              CustomDropdown<PriorityOrder>(
                label: "Priority",
                value: selectedPriority,
                hint: "Select priority",
                items: PriorityOrder.values,
                itemBuilder: (p) {
                  return Row(
                    children: [
                      Icon(Icons.circle,
                          color: AppHelper.getPriorityColor(p), size: 20),
                      const SizedBox(width: 8),
                      Text(p.name.toUpperCase()),
                    ],
                  );
                },
                onChanged: (p) => setState(() => selectedPriority = p),
                validator: (v) =>
                    AppHelper.required(v.toString(), "task priority"),
              ),
              const SizedBox(height: 20),

              /// DUE DATE PICKER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Due Date:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDueDate,
                    child: Text(
                      dueDate == null
                          ? "Pick Date"
                          : "${dueDate!.year}-${dueDate!.month}-${dueDate!.day}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              /// SUBMIT BUTTON
              CustomButton(
                title: widget.isEditing ? "Update Task" : "Add Task",
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
