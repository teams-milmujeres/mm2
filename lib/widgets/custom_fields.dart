import 'package:flutter/material.dart';

class EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const EditableField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class EditableDropdownField extends StatelessWidget {
  final String label;
  final int? value;
  final List<MapEntry<int, String>> entries;
  final ValueChanged<int?> onChanged;

  const EditableDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.entries,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: DropdownButtonFormField<int>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(labelText: label),
          items:
              entries
                  .map(
                    (entry) => DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
