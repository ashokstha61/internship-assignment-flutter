import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Book Finder App',
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system,
    home: MainScreen(),
  ));
}