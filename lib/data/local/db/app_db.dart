import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import '/data/local/entity/employee_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'app_db.g.dart';

LazyDatabase openConnection() => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(
        path.join(dbFolder.path, 'employee.sqlite'),
      );
      return NativeDatabase(file);
    });

@DriftDatabase(tables: [Employee])
class AppDb extends $AppDb {
  AppDb() : super(openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<EmployeeData>> getEmployees() async =>
      await (select(employee).get());

  Future<EmployeeData> getEmployee(int id) async =>
      await (select(employee)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<bool> updateEmployee(EmployeeCompanion entity) async =>
      await update(employee).replace(entity);

  Future<int> insertEmployee(EmployeeCompanion entity) async =>
      await into(employee).insert(entity);

  Future<int> deleteEmployee(int id) async =>
      await (delete(employee)..where((tbl) => tbl.id.equals(id))).go();
}
