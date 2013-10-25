part of todo_mvc_app;

class Todos implements ActionReactionApi {
  TodoApp _todoApp;

  List<Todo> _todoList = new List<Todo>();
  Element _todoElements = querySelector('#todo-list');

  Todos(this._todoApp) {
    _todoApp.domain.startActionReaction(this);
  }

  Todo _find(Task task) {
    for (Todo todo in _todoList) {
      if (todo.task == task) {
        return todo;
      }
    }
  }

  add(Task task) {
    var todo = new Todo(_todoApp, task);
    _todoList.add(todo);
    _todoElements.nodes.add(todo.element);
  }

  _complete(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.complete(task.completed);
    }
  }

  react(ActionApi action) {
    if (action is AddAction) {
      add((action as AddAction).entity);
    } else if (action is SetAttributeAction) {
      _complete((action as SetAttributeAction).entity);
    }
    _todoApp.updateFooter();
    _todoApp.save();
  }
}


