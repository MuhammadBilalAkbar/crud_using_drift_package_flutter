import 'package:crud_using_drift_package_flutter/constants/constants.dart';
import 'package:flutter/material.dart';

import 'route/route_generator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Drift CRUD App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            titleTextStyle: TextStyle(fontSize: 25),
          ),
          textTheme: const TextTheme(
            labelLarge: TextStyle(fontSize: 25),
          ),
        ),
        initialRoute: AppConstants.homeRoute,
        onGenerateRoute: RouteGenerator.generateRoute,
      );
}
