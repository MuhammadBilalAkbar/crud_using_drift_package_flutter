import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.textLabel,
  });

  final TextEditingController controller;
  final String textLabel;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(textLabel),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$textLabel can not be empty';
          }
          return null;
        },
    textInputAction: TextInputAction.next,
      );
}
