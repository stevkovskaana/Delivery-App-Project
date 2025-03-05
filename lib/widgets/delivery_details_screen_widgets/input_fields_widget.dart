import 'package:flutter/material.dart';

class InputFieldsWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final bool readOnly;
  final IconButton? iconButton;

  const InputFieldsWidget({
    super.key,
    required this.controller,
    required this.label,
    this.inputType = TextInputType.text,
    this.readOnly = false,
    this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: inputType,
                readOnly: readOnly,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter $label',
                ),
              ),
            ),
            if (iconButton != null) ...[
              const SizedBox(width: 10),
              iconButton!,
            ]
          ],
        ),
      ],
    );
  }
}
