import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_riverpod/models/task.dart';

final tasksApiProvider = FutureProvider<List<Task>>((ref) async {
  // FutureProvider represents async state
  // It can be in:
  // * loading
  // * data
  // * error

  print("API called");

  // ⏳ Simulate network delay
  await Future.delayed(const Duration(seconds: 1));

  // ✅ Fake API response (success case)
  return const [
    Task(id: '1', title: 'Learn Riverpod deeply', isDone: false, priority: Priority.high),
    Task(id: '2', title: 'Build TaskFlow app', isDone: false, priority: Priority.medium),
    Task(id: '3', title: 'Upload to GitHub', isDone: false, priority: Priority.low),
  ];
});
