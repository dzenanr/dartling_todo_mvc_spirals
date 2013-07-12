part of todo_mvc_app;

class Todos {
  Element _todoElements = query('#todo-list');

  add(Task task) {
    _todoElements.nodes.add(new Todo(task).element);
  }
}


