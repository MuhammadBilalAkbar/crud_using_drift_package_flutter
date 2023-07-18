import 'package:flutter/material.dart';

class CustomDatePickerFormField extends StatelessWidget {
  const CustomDatePickerFormField({
    Key? key,
    required this.dateOfBirthController,
    required this.label,
    required this.callback,
  }) : super(key: key);

  final TextEditingController dateOfBirthController;
  final String label;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: dateOfBirthController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(label),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label can not be empty';
          }
          return null;
        },
        onTap: callback,
      );
}
