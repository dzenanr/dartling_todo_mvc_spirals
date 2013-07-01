part of todo_mvc_app;

class TodoApp {
  TodoApp(TodoModels domain) {
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    Tasks tasks = model.getEntry('Task');

    var _todos = new Todos();

    InputElement newTodo = query('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          tasks.add(task);
          _todos.add(task);
          newTodo.value = '';
        }
      }
    });
  }
}
