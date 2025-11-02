import 'package:flutter/material.dart';
import 'package:weather_app/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = ThemeData.dark();
  void toggleTheme() {
    setState(() {
      theme = (theme == ThemeData.dark())
          ? ThemeData.light()
          : ThemeData.dark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: WeatherHome(toggleTheme: toggleTheme, theme: theme),
    );
  }
}
