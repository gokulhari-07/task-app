import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_riverpod/screens/tasks_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); //ProviderScope = dependency injection root for Riverpod. If this is missing, nothing will work later.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TasksScreen());
  }
}
