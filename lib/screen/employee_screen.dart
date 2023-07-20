/// Add, Edit, or Delete Employee Screen
import 'package:crud_using_drift_package_flutter/constants/constants.dart';
import 'package:flutter/material.dart';

import 'package:drift/drift.dart' as drift;

import '/data/local/db/app_db.dart';
import '/widgets/custom_date_picker_form_field.dart';

import '/widgets/custom_text_form_field.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({
    Key? key,
    this.id,
    required this.editMode,
  }) : super(key: key);

  final int? id;
  final bool editMode;

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
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
    if (widget.editMode == true) getEmployee();
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
    employeeData = await db.getEmployee(widget.id!);
    userNameController.text = employeeData.userName;
    firstNameController.text = employeeData.lastName;
    lastNameController.text = employeeData.firstName;
    dateOfBirthController.text = employeeData.dateOfBirth.toString();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: widget.editMode
              ? const Text('Edit Employee')
              : const Text('Add Employee'),
          actions: [
            IconButton(
              onPressed: () {
                widget.editMode ? editEmployee() : addEmployee();
                Navigator.pushNamedAndRemoveUntil(
                    context, AppConstants.homeRoute, (route) => false);
              },
              icon: const Icon(Icons.save),
            ),
            Visibility(
              visible: widget.editMode,
              child: IconButton(
                onPressed: deleteEmployee,
                icon: const Icon(Icons.delete),
              ),
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
                    label: 'Date of Birth',
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
        dateOfBirthController.text = newDate.toString();
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
      Navigator.pushNamedAndRemoveUntil(
          context, AppConstants.homeRoute, (route) => false);
    }
  }

  void editEmployee() {
    final isValid = formKey.currentState?.validate();
    if (isValid != null && isValid) {
      final entity = EmployeeCompanion(
        id: drift.Value(widget.id!),
        userName: drift.Value(userNameController.text),
        firstName: drift.Value(firstNameController.text),
        lastName: drift.Value(lastNameController.text),
        dateOfBirth: widget.editMode
            ? drift.Value(DateTime.parse(dateOfBirthController.text))
            : drift.Value(dateOfBirth!),
      );

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
      Navigator.pushNamedAndRemoveUntil(
          context, AppConstants.homeRoute, (route) => false);
    }
  }

  void deleteEmployee() {
    db.deleteEmployee(widget.id!).then(
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
    Navigator.pushNamedAndRemoveUntil(
        context, AppConstants.homeRoute, (route) => false);
  }
}
