import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_database/dbhelper.dart';
import 'package:sqlite_database/dbprovider.dart';
import 'package:sqlite_database/homepage.dart';
import 'package:sqlite_database/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DBProvider(
            dbHelper: DBHelper.getInstanse,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final DBHelper db = DBHelper.getInstanse;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: context.watch<ThemeProvider>().getThemeValue()
          ? ThemeMode.dark
          : ThemeMode.light,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      darkTheme: ThemeData.dark(),

      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}