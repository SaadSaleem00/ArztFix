import 'package:flutter/material.dart';
import 'package:myapp/app_router.dart'; // Import the app_router.dart file
// Replace 'myapp' with your actual project name

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, // Use the GoRouter instance from app_router.dart
    );
  }
}
