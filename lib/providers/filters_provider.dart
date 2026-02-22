import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:taskflow_riverpod/models/task.dart';
import 'package:taskflow_riverpod/providers/tasks_provider.dart';

enum Filters { all, done, pending, high, medium, low }

/// Stores the currently selected filter
final filtersProvider = StateProvider<Filters>((ref) {
  return Filters.all;
});

// How you’ll use it in UI:

// Read current filter:
// final filter = ref.watch(filtersProvider);

// Change filter:
// ref.read(filtersProvider.notifier).state = Filters.completed;

final filteredTasksProvider = Provider<List<Task>>((ref) {
  //derived provider
  //rule: Derived providers must be pure. They should never call methods that change state.
  final tasks = ref.watch(tasksProvider);
  final filter = ref.watch(filtersProvider);

  switch (filter) {
    case Filters.all:
      return tasks;

    case Filters.done:
      return tasks.where((task) => task.isDone).toList();

    case Filters.pending:
      return tasks.where((task) => !task.isDone).toList();

    case Filters.high:
      return tasks.where((task) => task.priority == Priority.high).toList();

    case Filters.medium:
      return tasks.where((task) => task.priority == Priority.medium).toList();

    case Filters.low:
      return tasks.where((task) => task.priority == Priority.low).toList();
  }
});

/*
===============================================================
🧠 REVISION NOTE: FILTERING vs MUTATION (RIVERPOD IMMUTABILITY)
===============================================================

❓ DO THE if/where CONDITIONS MUTATE STATE?
No. This code does NOT mutate any state:

  tasks.where((task) => task.isDone).toList();
  tasks.where((task) => !task.isDone).toList();
  tasks.where((task) => task.priority == Priority.high).toList();

These operations:
- ❌ Do NOT change the original `tasks` list
- ❌ Do NOT change any `Task` object
- ✅ Only READ properties (task.isDone, task.priority)
- ✅ Create and return a NEW List

This is called PURE DERIVATION (safe for Riverpod).

---------------------------------------------------------------
🚨 WHAT COUNTS AS MUTATION (DO NOT DO IN DERIVED PROVIDERS)

Examples of MUTATION:
  task.isDone = true;            // ❌ mutating an object
  state.add(newTask);           // ❌ mutating a list
  state.remove(task);           // ❌ mutating a list
  ref.read(provider.notifier).toggleTask(id);  // ❌ side effect

Derived providers must NEVER:
- Call notifier methods
- Modify provider state
- Cause side effects

---------------------------------------------------------------
✅ RIVERPOD RULE (MEMORIZE THIS):

Derived providers must be PURE FUNCTIONS:
Input  → (read state only)
Output → computed data
No side effects, no state changes.

Filtering data is NOT mutation.
Mutation means changing existing objects.

---------------------------------------------------------------
🧠 QUICK TEST (MENTAL CHECK):

If you see:
  - assignment (=) on model fields → ❌ mutation
  - add/remove on state lists     → ❌ mutation
  - where/map/toList + reads     → ✅ safe

===============================================================
*/
