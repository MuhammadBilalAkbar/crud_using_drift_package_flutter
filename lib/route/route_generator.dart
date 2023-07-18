import 'package:crud_using_drift_package_flutter/constants/constants.dart';
import 'package:flutter/material.dart';

import '/screen/home_screen.dart';
import '/screen/add_employee_screen.dart';
import '/screen/edit_or_delete_employee_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppConstants.addEmployeeRoute:
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());
      case AppConstants.editOrDeleteEmployeeRoute:
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => EditOrDeleteEmployeeScreen(id: args),
          );
        }
        return errorRoute();
      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('No Route'),
        ),
        body: const Center(
          child: Text(
            'Sorry no route was found!',
            style: TextStyle(color: Colors.red, fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
