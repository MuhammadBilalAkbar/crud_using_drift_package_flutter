import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

import '/data/local/db/app_db.dart';
import '/widgets/custom_date_picker_form_field.dart';

import '/widgets/custom_text_form_field.dart';

class EditOrDeleteEmployeeScreen extends StatefulWidget {
  const EditOrDeleteEmployeeScreen({
    Key? key,
    required this.id,
  }) : super(key: key);
  final int id;

  @override
  State<EditOrDeleteEmployeeScreen> createState() =>
      _EditOrDeleteEmployeeScreenState();
}

class _EditOrDeleteEmployeeScreenState
    extends State<EditOrDeleteEmployeeScreen> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  DateTime? dateOfBirth;
  late AppDb db;
  late EmployeeData employeeData;

  @override
  void initState() {
    super.initState();
    db = AppDb();
    getEmployee();
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

  Future<void> getEmployee() async {
    employeeData = await db.getEmployee(widget.id);
    userNameController.text = employeeData.userName;
    firstNameController.text = employeeData.lastName;
    lastNameController.text = employeeData.firstName;
    dateOfBirthController.text = employeeData.dateOfBirth.toString();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Employee'),
          actions: [
            IconButton(
              onPressed: () {
                editEmployee();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              icon: const Icon(Icons.save),
            ),
            IconButton(
              onPressed: deleteEmployee,
              icon: const Icon(Icons.delete),
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

  void deleteEmployee() {
    // db.deleteEmployee(widget.id);
    db.deleteEmployee(widget.id).then(
      (value) {
        return ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.pink,
            content: Text(
              'Employee deleted: ${widget.id}',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              Builder(
                builder: (context) => TextButton(
                  onPressed: () =>
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void editEmployee() {
    final isValid = formKey.currentState?.validate();
    if (isValid != null && isValid) {
      final entity = EmployeeCompanion(
        id: drift.Value(widget.id),
        userName: drift.Value(userNameController.text),
        firstName: drift.Value(firstNameController.text),
        lastName: drift.Value(lastNameController.text),
        dateOfBirth: drift.Value(dateOfBirth!),
      );

      // db.updateEmployee(entity);
      db.updateEmployee(entity).then(
            (value) => ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.pink,
                content: Text(
                  'Employee updated: ${widget.id}',
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
