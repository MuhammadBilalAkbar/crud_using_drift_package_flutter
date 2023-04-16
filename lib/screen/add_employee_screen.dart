import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

import '/data/local/db/app_db.dart';
import '/widget/custom_date_picker_form_field.dart';

import '/widget/custom_text_form_field.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  DateTime? dateOfBirth;
  late AppDb db;

  @override
  void initState() {
    super.initState();
    db = AppDb();
  }

  @override
  void dispose() {
    db.close();
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Add Employee'),
          actions: [
            IconButton(
              onPressed: addEmployee,
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextFormField(
                    textLabel: 'User name',
                    controller: userNameController,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    textLabel: 'First name',
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    textLabel: 'Last name',
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 8),
                  CustomDatePickerFormField(
                    dateOfBirthController: dateOfBirthController,
                    txtLabel: 'Date of Birth',
                    callback: () => pickDateOfBirth(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> pickDateOfBirth(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? initialDate,
      firstDate: DateTime(initialDate.year - 100),
      lastDate: DateTime(initialDate.year + 1),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.pink,
            onPrimary: Colors.white,
            onSurface: Colors.black,
            background: Colors.white,
          ),
        ),
        child: child ?? const Text(''),
      ),
    );
    if (newDate == null) {
      return;
    }
    setState(() {
      dateOfBirth = newDate;
      final dob = DateFormat('dd/MM/yyyy').format(newDate);
      dateOfBirthController.text = dob;
    });
  }

  void addEmployee() {
    final isValid = formKey.currentState?.validate();
    if (isValid != null && isValid) {
      final entity = EmployeeCompanion(
        userName: drift.Value(userNameController.text),
        firstName: drift.Value(firstNameController.text),
        lastName: drift.Value(lastNameController.text),
        dateOfBirth: drift.Value(dateOfBirth!),
      );

      // db.insertEmployee(entity);
      db.insertEmployee(entity).then(
            (value) => ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.pink,
                content: Text(
                  'New employee inserted: $value',
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  Builder(
                    builder: (context) => TextButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .hideCurrentMaterialBanner(),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }
}
