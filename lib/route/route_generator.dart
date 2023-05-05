import 'package:flutter/material.dart';

import '/screen/edit_or_delete_employee_screen.dart';
import '/screen/add_employee_screen.dart';
import '/screen/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/add_employee':
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());
      case '/edit_employee':
        if (args is int) {
          return MaterialPageRoute(
              builder: (_) => EditOrDeleteEmployeeScreen(id: args));
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
