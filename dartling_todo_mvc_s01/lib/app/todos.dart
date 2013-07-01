part of todo_mvc_app;

class Todos {
  Element _todoElements = query('#todo-list');

  Todos();

  add(Task task) {
    var todo = new Todo(task);
    _todoElements.nodes.add(todo.create());
  }
}


