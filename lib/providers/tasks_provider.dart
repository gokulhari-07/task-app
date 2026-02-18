import 'package:flutter_riverpod/legacy.dart';
import 'package:taskflow_riverpod/models/task.dart';

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super([]);

  void addTask(String title, Priority priority) {
    state = [
      ...state,
      Task(
        id: DateTime.now().millisecondsSinceEpoch
            .toString(), // cnverts current date and time to a unique number. This number means the number of milliseconds passed since Jan 1, 1970(Unix Epoch). This number keeps increasing and is very unlikely to repeat, so it’s useful as a simple unique ID. Later upgrade to uuid package in production which is better than this.
        title: title,
        priority: priority,
      ),
    ];
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  bool toggleTask(String id) {
    bool updatedStatus = false;
    state = state.map((task) {
      if (task.id == id) {
        final updatedTask = task.copyWith(isDone: !task.isDone);
        updatedStatus = updatedTask.isDone;
        return updatedTask;
      }
      return task;
    }).toList();
    return updatedStatus; //returning bool is not needed currntly actually so remove type bool from this fn n make it simpler.
  }

  void setTasks(List<Task> tasks) {
//🧠 Why this method exists:
//      API data should not directly control UI
//      TasksNotifier remains the single source of truth
//      Async provider feeds data into app state
    state = tasks;
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});
