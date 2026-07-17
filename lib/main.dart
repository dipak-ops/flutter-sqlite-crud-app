import 'package:flutter/material.dart';
import 'package:sqlite_database/dbhelper.dart';
import 'package:sqlite_database/homepage.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  MyApp({super.key});

  final DBHelper db=DBHelper.getInstanse;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}