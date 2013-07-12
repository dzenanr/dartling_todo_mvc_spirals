part of todo_mvc_app;

class Todos {
  TodoApp _todoApp;
  List<Todo> _todoList = new List<Todo>();
  Element _todoElements = query('#todo-list');

  Todos(this._todoApp);

  Todo _find(Task task) {
    for (Todo todo in _todoList) {
      if (todo._task == task) {
        return todo;
      }
    }
  }

  add(Task task) {
    var todo = new Todo(_todoApp, task);
    _todoList.add(todo);
    _todoElements.nodes.add(todo.element);
  }

  complete(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.complete(task.completed);
    }
  }
}


