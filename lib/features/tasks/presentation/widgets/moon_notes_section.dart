import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';

class MoonNotesSection extends StatefulWidget {
  const MoonNotesSection({super.key, required this.task});

  final Task task;

  @override
  State<MoonNotesSection> createState() => _MoonNotesSectionState();
}

class _MoonNotesSectionState extends State<MoonNotesSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<TasksViewModel>().addNote(widget.task.id, text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final notes = widget.task.notes.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MOON NOTES · ${notes.length}', style: text.labelSmall),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: [LengthLimitingTextInputFormatter(280)],
          onSubmitted: (_) => _add(),
          decoration: InputDecoration(
            hintText: 'Add a note…',
            suffixIcon: IconButton(
              tooltip: 'Add note',
              icon: const Icon(Icons.add),
              onPressed: _add,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (notes.isEmpty)
          Text(
            'No moons yet. Every note you add will orbit this planet.',
            style: text.bodySmall,
          )
        else
          for (final note in notes)
            _NoteCard(
              note: note,
              onDelete: () => context.read<TasksViewModel>().deleteNote(
                widget.task.id,
                note.id,
              ),
            ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note, required this.onDelete});

  final Note note;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final orbit = context.orbit;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: orbit.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: orbit.muted,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.text, style: text.bodyMedium),
                    const SizedBox(height: 2),
                    Text(
                      MaterialLocalizations.of(context)
                          .formatMediumDate(note.createdAt),
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete note',
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
