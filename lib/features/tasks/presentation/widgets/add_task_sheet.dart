import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';
import 'package:orbit_planner/features/tasks/presentation/orbit/orbit_layout.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';

Future<void> showAddTaskSheet(BuildContext context) =>
    _showTaskSheet(context, null);

Future<void> showEditTaskSheet(BuildContext context, Task task) =>
    _showTaskSheet(context, task);

Future<void> _showTaskSheet(BuildContext context, Task? task) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 560),
    builder: (_) => AddTaskSheet(task: task),
  );
}

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key, this.task});

  final Task? task;

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  late TaskCategory _category;
  late TaskPriority _priority;
  late DateTime _dueDate;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _category = task?.category ?? TaskCategory.study;
    _priority = task?.priority ?? TaskPriority.medium;
    _dueDate = task == null ? _dateFromToday(3) : _dateOnly(task.dueDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = _dateFromToday(0);
    final first = _dueDate.isBefore(today) ? _dueDate : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: first,
      lastDate: _dateFromToday(365 * 3),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<TasksViewModel>();

    if (_isEditing) {
      vm.updateTask(
        widget.task!.id,
        title: title,
        category: _category,
        priority: _priority,
        dueDate: _dueDate,
      );
    } else {
      vm.addTask(
        title: title,
        category: _category,
        priority: _priority,
        dueDate: _dueDate,
      );
    }

    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Changes saved' : 'Planet launched: $title'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final orbit = context.orbit;
    final days = _daysFromToday(_dueDate);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Edit planet' : 'New planet',
                style: text.headlineMedium,
              ),
              const SizedBox(height: 12),
              _PlanetPreview(
                color: _category.color(orbit),
                priority: _priority,
                ring: OrbitLayout.ringFor(days),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                inputFormatters: [LengthLimitingTextInputFormatter(60)],
                decoration: const InputDecoration(
                  hintText: 'What needs to orbit you?',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Give your planet a name'
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 20),
              Text('CATEGORY', style: text.labelSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in TaskCategory.values)
                    ChoiceChip(
                      label: Text(category.label),
                      avatar: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: category.color(orbit),
                          shape: BoxShape.circle,
                        ),
                      ),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text('PRIORITY', style: text.labelSmall),
              Slider(
                value: _priority.index.toDouble(),
                min: 0,
                max: TaskPriority.values.length - 1.0,
                divisions: TaskPriority.values.length - 1,
                label: _priority.label,
                onChanged: (v) =>
                    setState(() => _priority = TaskPriority.values[v.round()]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final p in TaskPriority.values)
                    Text(p.label, style: text.bodySmall),
                ],
              ),
              const SizedBox(height: 20),
              Text('DEADLINE', style: text.labelSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (label, offset) in const [
                    ('Today', 0),
                    ('Tomorrow', 1),
                    ('Next week', 7),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: days == offset,
                      onSelected: (_) =>
                          setState(() => _dueDate = _dateFromToday(offset)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: Text(
                  MaterialLocalizations.of(context).formatMediumDate(_dueDate),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: Text(_isEditing ? 'Save changes' : 'Launch planet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanetPreview extends StatelessWidget {
  const _PlanetPreview({
    required this.color,
    required this.priority,
    required this.ring,
  });

  final Color color;
  final TaskPriority priority;
  final int ring;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final orbit = context.orbit;

    // نفس نسب الـ Orbit View عشان المعاينة تطابق اللي هيظهر
    final diameter = OrbitLayout.planetRadius(priority) * 2000;
    final (title, hint) = switch (ring) {
      0 => ('Inner orbit', 'Due within 3 days, close to the sun'),
      1 => ('Middle orbit', 'Due within a week'),
      _ => ('Outer orbit', 'More than a week away'),
    };

    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: orbit.shadow, offset: const Offset(2, 2)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.titleMedium),
              const SizedBox(height: 2),
              Text(hint, style: text.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _dateFromToday(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days);
}

int _daysFromToday(DateTime date) {
  final now = DateTime.now();
  final today = DateTime.utc(now.year, now.month, now.day);
  return DateTime.utc(date.year, date.month, date.day).difference(today).inDays;
}
