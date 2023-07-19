import 'package:crud_using_drift_package_flutter/constants/constants.dart';
import 'package:flutter/material.dart';

import '/screen/home_screen.dart';
import '/screen/employee_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.homeRoute:
        debugPrint('settings.name for homeRoute: ${settings.name}');
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppConstants.editOrDeleteEmployeeRoute:
        debugPrint(
            'settings.name for editOrDeleteEmployeeRoute: ${settings.name}');
        // if (settings.name == AppConstants.editOrDeleteEmployeeRoute) {
        final args = settings.arguments as ScreenArguments?;
        if (args?.id != null) {
          return MaterialPageRoute(
            builder: (_) => EmployeeScreen(
              id: args!.id,
              editMode: args.editMode,
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => EmployeeScreen(
              editMode: args!.editMode,
            ),
          );
        }
      // }
      // break;
      default:
        return errorRoute();
    }
    // return errorRoute();
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
