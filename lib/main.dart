import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taxichrono/home_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final database = openDatabase(
    join(await getDatabasesPath(), 'task_database.db'),
    onCreate: (db, int version) {
      return db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, desc TEXT)',
      );
    },
    version: 1,
  );
  runApp(MyApp(
    database: database,
  ));
}

class MyApp extends StatelessWidget {
  final Future<Database> database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD aplication',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blueGrey,
      ),
      home: HomeScreen(database: database),
    );
  }
}


