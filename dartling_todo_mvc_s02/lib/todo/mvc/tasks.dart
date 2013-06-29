part of todo_mvc;

// lib/todo/mvc/tasks.dart

class Task extends TaskGen {

  Task(Concept concept) : super(concept);

  // begin: added by hand
  bool get left => !completed;
  bool get generate =>
      title.contains('generate') ? true : false;
  // end: added by hand

}

class Tasks extends TasksGen {

  Tasks(Concept concept) : super(concept);

  // begin: added by hand
  Tasks get completed => selectWhere((task) => task.completed);
  Tasks get left => selectWhere((task) => task.left);
  // end: added by hand

}
