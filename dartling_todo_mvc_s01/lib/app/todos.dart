part of todo_mvc_app;

class Todos {
  Element _todoList = query('#todo-list');

  add(Task task) {
    _todoList.nodes.add(new Todo(task).element);
  }
}


