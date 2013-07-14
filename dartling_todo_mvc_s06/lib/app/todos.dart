part of todo_mvc_app;

class Todos implements ActionReactionApi {
  TodoApp _todoApp;

  List<Todo> _todoList = new List<Todo>();
  Element _todoElements = query('#todo-list');

  Todos(this._todoApp) {
    _todoApp.domain.startActionReaction(this);
  }

  Iterator<Todo> get iterator => _todoList.iterator;

  add(Task task) {
    var todo = new Todo(_todoApp, task);
    _todoList.add(todo);
    _todoElements.nodes.add(todo.element);
  }

  Todo _find(Task task) {
    for (Todo todo in _todoList) {
      if (todo.task == task) {
        return todo;
      }
    }
  }

  _complete(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.complete(task.completed);
    }
  }

  _retitle(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.retitle(task.title);
    }
  }

  _remove(Task task) {
    var todo = _find(task);
    if (todo != null) {
      _todoList.remove(todo);
      todo.remove();
    }
  }

  react(ActionApi action) {
    updateTodo(SetAttributeAction action) {
      if (action.property == 'completed') {
        _complete(action.entity);
      } else if (action.property == 'title') {
        _retitle(action.entity);
      }
    }

    if (action is Transaction) {
      for (var transactionAction in action.past.actions) {
        if (transactionAction is SetAttributeAction) {
          updateTodo(transactionAction);
        } else if (transactionAction is RemoveAction) {
          if (transactionAction.undone) {
            add(transactionAction.entity);
          } else {
            _remove(transactionAction.entity);
          }
        }
      }
    } else if (action is AddAction) {
      if (action.undone) {
        _remove(action.entity);
      } else {
        add(action.entity);
      }
    } else if (action is RemoveAction) {
      if (action.undone) {
        add(action.entity);
      } else {
        _remove(action.entity);
      }
    } else if (action is SetAttributeAction) {
      updateTodo(action);
    }

    _todoApp.updateDisplay();
    _todoApp.save();
  }
}


