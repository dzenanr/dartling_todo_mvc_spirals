part of todo_mvc_app;

class Todos {
  DomainSession _session;

  List<Todo> _todoList = new List<Todo>();
  Element _todoElements = query('#todo-list');

  Todos(this._session);

  Todo _find(Task task) {
    for (Todo todo in _todoList) {
      if (todo.task == task) {
        return todo;
      }
    }
  }

  add(Task task) {
    var todo = new Todo(_session, task);
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


