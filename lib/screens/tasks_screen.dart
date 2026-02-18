import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_riverpod/models/task.dart';
import 'package:taskflow_riverpod/providers/filters_provider.dart';
import 'package:taskflow_riverpod/providers/task_api_provider.dart';
import 'package:taskflow_riverpod/providers/tasks_provider.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() {
    return _TasksScreenState();
  }
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  Priority _selectedPriority = Priority.medium;
  final TextEditingController _addTaskController = TextEditingController();

  // 🧠 Guard flag: ensure API data is applied only once
  bool _didInitFromApi = false;

  @override
  void dispose() {
    _addTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncTasks = ref.watch(tasksApiProvider);
    final tasks = ref.watch(filteredTasksProvider);
    final selectedFilter = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Task")),
      body: asyncTasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (err, _) => Center(
          child: Text("Error: $err"),
        ),

        data: (apiTasks) {
          // ✅ Apply API data to app state only once
          if (!_didInitFromApi) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(tasksProvider.notifier).setTasks(apiTasks);
            });
            _didInitFromApi = true;
          }

          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: TextField(controller: _addTaskController)),
                  DropdownButton(
                    value: _selectedPriority,
                    items: Priority.values
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          _selectedPriority = value;
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_addTaskController.text.isNotEmpty) {
                        ref
                            .read(tasksProvider.notifier)
                            .addTask(_addTaskController.text, _selectedPriority);
                        _addTaskController.clear();
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              Row(
                children: [
                  const Spacer(),
                  DropdownButton<Filters>(
                    value: selectedFilter,
                    items: Filters.values
                        .map(
                          (filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(filtersProvider.notifier).state = value;
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      tasks[index].title,
                      style: TextStyle(
                        decoration: tasks[index].isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: tasks[index].isDone,
                      onChanged: (_) {
                        ref
                            .read(tasksProvider.notifier)
                            .toggleTask(tasks[index].id);
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(tasksProvider.notifier)
                            .deleteTask(tasks[index].id);
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
// 🧠 REVISION NOTE — Riverpod AsyncValue.when()

// When using FutureProvider in Riverpod, ref.watch(myFutureProvider) does NOT give
// the actual data directly. It gives an AsyncValue<T>, which represents 3 possible states:

// 1️⃣ loading
//    → The Future is still running (API call in progress)
//    → Use this to show:
//      - CircularProgressIndicator
//      - Skeleton UI
//      - “Loading…” message

// 2️⃣ error
//    → The Future failed (network error, server error, etc.)
//    → Use this to show:
//      - Error message
//      - Retry button (later when using real APIs)

// 3️⃣ data
//    → The Future completed successfully
//    → This is where the REAL UI of the screen should be built
//    → The parameter passed into `data: (value) { ... }` is the API result

// Example:

// final asyncValue = ref.watch(tasksApiProvider);

// return asyncValue.when(
//   loading: () => LoadingUI(),
//   error: (err, stack) => ErrorUI(err),
//   data: (data) => MainScreen(data),
// );

// WHY the whole screen is built inside `data:`:
// - Before API data arrives, the app does not yet have the data to show.
// - So:
//   loading  → show loading UI
//   error    → show error UI
//   data     → show full screen UI
// - This prevents:
//   ❌ null errors
//   ❌ broken UI
//   ❌ reading data before it exists

// Mental Model:
// `.when()` acts like a gate that decides which UI to show based on async state:

// Loading → show spinner  
// Error   → show error UI  
// Data    → show full app UI  

// One-liner to remember:
// “.when() maps async state (loading/error/data) to UI states.”


// 🧠 REVISION NOTE — Async Builds, addPostFrameCallback & _didInitFromApi (Riverpod + Flutter)

// 🔹 1) Flutter builds async UI in phases (IMPORTANT)
// When using FutureProvider, Flutter builds the screen multiple times:

// - First build:
//   Future is still running → async state = loading  
//   UI shown = Loading UI (spinner, skeleton, etc.)
//   No provider state is modified here → no errors

// - Second build:
//   Future completes → async state = data(apiData)  
//   Flutter rebuilds UI using the `data:` branch  
//   ⚠️ THIS is where the common error happens if you try to update another provider inside build()

// ----------------------------------------

// 🔹 2) Why the error happens in the second build

// If you do this inside:

// asyncValue.when(
//   data: (apiData) {
//     ref.read(myNotifierProvider.notifier).setState(apiData);  ❌
//     return RealUI();
//   },
// )

// Riverpod throws:
// “Tried to modify a provider while the widget tree was building”

// Reason:
// Flutter is still in the middle of building widgets for the current frame.
// Mutating global/app state during build can cause:
// - infinite rebuild loops
// - inconsistent UI
// - hard-to-debug state issues

// So Riverpod blocks it.

// ----------------------------------------

// 🔹 3) What WidgetsBinding.instance.addPostFrameCallback does

// This line:

// WidgetsBinding.instance.addPostFrameCallback((_) {
//   ref.read(myNotifierProvider.notifier).setState(apiData);
// });

// Means:
// “Wait until Flutter finishes building AND painting the current UI frame,
// then update the provider state.”

// This safely moves the state update to AFTER the second build finishes.

// ----------------------------------------

// 🔹 4) Simple analogy (not the chef one)

// Think of Flutter build like:
// A slide projector switching slides.

// While a slide is being switched (build phase), you cannot change the slide content.
// You wait until the slide is fully shown on screen (painted frame),
// then change the content for the next slide.

// addPostFrameCallback = “Change content AFTER the current slide is fully shown.”

// ----------------------------------------

// 🔹 5) Why _didInitFromApi is needed

// If API data is copied into app state like this:

// WidgetsBinding.instance.addPostFrameCallback((_) {
//   ref.read(tasksProvider.notifier).setTasks(apiTasks);
// });

// This runs on every rebuild.
// Widgets rebuild when:
// - user adds a task
// - toggles checkbox
// - deletes a task
// - changes filter

// So API data would overwrite user changes repeatedly.

// Fix:
// Use a guard flag:

// bool _didInitFromApi = false;

// if (!_didInitFromApi) {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     ref.read(tasksProvider.notifier).setTasks(apiTasks);
//   });
//   _didInitFromApi = true;
// }

// This ensures API data is applied only once when it first arrives.

// ----------------------------------------

// 🔹 6) One-line summary to remember

// - Async UI builds in phases: loading → data (or error)
// - The “modify provider during build” error happens in the SECOND build (data build)
// - Use addPostFrameCallback to delay state updates until after the frame is rendered
// - Use _didInitFromApi to prevent overwriting user changes on every rebuild


// 🎯 INTERVIEW PRACTICE — Riverpod FutureProvider & Async UI

// Q1. What does FutureProvider do in Riverpod?
// A: It handles asynchronous data (like API calls) and exposes the async state as AsyncValue<T>, which can be loading, error, or data.

// Q2. What is AsyncValue?
// A: AsyncValue<T> represents the state of an async operation:
// - loading → Future still running
// - error → Future failed
// - data → Future succeeded with value

// Q3. Why do we use .when() on AsyncValue?
// A: .when() maps async states to UI states. It forces us to handle loading, error, and data explicitly and avoids null errors and broken UI.

// Q4. What happens when you call ref.watch(myFutureProvider)?
// A: The widget subscribes to the provider and rebuilds whenever the async state changes (loading → data/error).

// Q5. Does Flutter wait for async data before building UI?
// A: No. Flutter builds UI immediately. While data is loading, it shows loading UI. When data arrives, it rebuilds.

// Q6. What are the “first build” and “second build” in async UI?
// A:
// - First build: async state is loading → loading UI is built.
// - Second build: async state becomes data/error → real UI or error UI is built.

// Q7. Why can’t we modify a Riverpod provider inside build()?
// A: Because Flutter is constructing the widget tree during build(). Mutating global state at this time can cause infinite rebuild loops or inconsistent UI. Riverpod blocks this.

// Q8. What error do you get if you update a provider during build()?
// A: “Tried to modify a provider while the widget tree was building.”

// Q9. Why does this error usually happen during the second build?
// A: Because developers try to push API data into another provider (StateNotifier) inside the data: branch of .when(), which runs during build().

// Q10. How do you safely update provider state when async data arrives?
// A: By delaying the update until after the current frame is rendered:
// WidgetsBinding.instance.addPostFrameCallback((_) {
//   ref.read(myNotifierProvider.notifier).setState(apiData);
// });

// Q11. Why is a guard flag like _didInitFromApi needed?
// A: Widgets rebuild often. Without a guard, API data would overwrite user changes on every rebuild. The flag ensures API data is applied only once.

// Q12. What happens if you don’t use _didInitFromApi?
// A: User actions (add/toggle/delete) get overwritten when the widget rebuilds.

// Q13. Why shouldn’t UI directly depend on FutureProvider for mutations?
// A: Because FutureProvider represents remote async state. The app’s source of truth should be a StateNotifier so user interactions are consistent and testable.

// Q14. What’s the role of StateNotifier when using FutureProvider?
// A: StateNotifier holds app state. FutureProvider fetches initial data and feeds it once into the notifier. All further mutations happen in the notifier.

// Q15. Is this pattern production-ready for real APIs (Firebase/REST)?
// A: Yes. This pattern (FutureProvider + AsyncValue.when() + StateNotifier) is commonly used in production Flutter apps.

// Q16. What will the user see if the API is slow?
// A: The loading UI defined in loading: of .when().

// Q17. How do you retry a FutureProvider?
// A: By calling:
// ref.invalidate(myFutureProvider);

// Q18. Difference between FutureProvider and StreamProvider?
// A:
// - FutureProvider → one-time async result (API call)
// - StreamProvider → continuous updates (Firebase streams, sockets)
