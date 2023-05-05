import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/data/local/db/app_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDb db;

  List<EmployeeData> employeesForUi = [];
  List<EmployeeData> employeeFromApi = [];

  @override
  void initState() {
    super.initState();
    db = AppDb();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Future<List<EmployeeData>> refreshUsersFromApi() async {
    final employeesFromApi = await db.getEmployees();
    setState(() {
      employeesForUi = employeesFromApi;
    });
    return employeesForUi;
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('CRUD Operations With Drift Flutter'),
        ),
        body: RefreshIndicator(
          onRefresh: refreshUsersFromApi,
          child: FutureBuilder<List<EmployeeData>>(
            future: db.getEmployees(),
            builder: (context, snapshot) {
              final employees = snapshot.data;
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (employees != null) {
                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/edit_employee',
                        arguments: employee.id,
                      ),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.green,
                            style: BorderStyle.solid,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(employee.id.toString()),
                              Text(employee.userName),
                              Text(employee.firstName),
                              Text(employee.lastName),
                              Text(employee.dateOfBirth.toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Text('No data found');
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/add_employee'),
          icon: const Icon(Icons.add),
          label: const Text('Add Employee'),
        ),
      );
}
