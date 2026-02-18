enum Priority { low, medium, high }


class Task {
  const Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.priority = Priority.low,
  });

  final String id;
  final String title;
  final bool isDone;
  final Priority priority;

  Task copyWith({String? id, String? title, bool? isDone, Priority? priority}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone, //If isDone was provided → use it. Else → keep the old value (this.isDone)
      priority: priority ?? this.priority,
    );
  }
  /*
===============================================================
🧠 REVISION NOTE: WHY copyWith() EXISTS (AND WHY NOT "NORMAL WAY")
===============================================================

❓ PROBLEM:
In Flutter + Riverpod, we follow IMMUTABLE STATE.
This means:
❌ Do NOT modify existing objects
✅ Always create NEW objects when updating state

So this is WRONG:
  task.isDone = true;   // mutating the same object in memory

Because:
- Riverpod/Flutter may not detect changes reliably
- UI updates can become buggy
- Mutating shared state causes unpredictable behavior

---------------------------------------------------------------
✅ SOLUTION: copyWith()

copyWith() means:
"Create a NEW copy of this object, but change only the fields I specify."

Example:
  final updatedTask = task.copyWith(isDone: true);

This creates a NEW Task object:
- id stays same
- title stays same
- priority stays same
- only isDone changes

---------------------------------------------------------------
🧩 HOW copyWith() WORKS:

Task copyWith({
  String? id,
  String? title,
  bool? isDone,
  Priority? priority,
}) {
  return Task(
    id: id ?? this.id,
    title: title ?? this.title,
    isDone: isDone ?? this.isDone,
    priority: priority ?? this.priority,
  );
}

Each field:
- uses the new value if provided
- otherwise keeps the old value

---------------------------------------------------------------
🚨 WHY NOT CREATE OBJECT MANUALLY EVERY TIME?

Bad & error-prone:
  Task(
    id: task.id,
    title: task.title,
    isDone: !task.isDone,
    priority: task.priority,
  );

Problems:
- Repetitive boilerplate
- Easy to forget fields when model grows
- More bugs when new fields are added later

copyWith() is future-proof:
  task.copyWith(isDone: !task.isDone);

This line will still work even if new fields are added to Task later.

---------------------------------------------------------------
🎯 KEY TAKEAWAY (MEMORIZE THIS):

Riverpod expects IMMUTABLE updates.
You NEVER change existing objects.
You ALWAYS create new objects.
copyWith() is the cleanest way to do that.

Think of copyWith as:
🖨 "Photocopy this object, but change only what I mention."

===============================================================
*/

}
