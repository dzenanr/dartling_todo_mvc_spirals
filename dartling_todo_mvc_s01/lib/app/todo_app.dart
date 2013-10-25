part of todo_mvc_app;

class TodoApp {
  TodoApp(Tasks tasks) {
    var todos = new Todos();

    InputElement newTodo = querySelector('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          tasks.add(task);
          todos.add(task);
          newTodo.value = '';
        }
      }
    });
  }
}

