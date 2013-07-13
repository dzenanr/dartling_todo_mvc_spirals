part of todo_mvc_app;

class Todos implements ActionReactionApi {
  TodoApp _todoApp;

  List<Todo> _todoList = new List<Todo>();
  Element _todoElements = query('#todo-list');
  Element _allElements = query('#filter a[href="#/"]');
  Element _leftElements = query('#filter a[href="#/left"]');
  Element _completedElements = query('#filter a[href="#/completed"]');

  Todos(this._todoApp) {
    window.onHashChange.listen((e) => updateFilter());
    _todoApp.domain.startActionReaction(this);
  }

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

  updateFilter() {
    switch(window.location.hash) {
      case '#/left':
        showLeft();
        break;
      case '#/completed':
        showCompleted();
        break;
      default:
        showAll();
        break;
    }
  }

  showAll() {
    _setSelectedFilter(_allElements);
    for (Todo todo in _todoList) {
      todo.visible = true;
    }
  }

  showLeft() {
    _setSelectedFilter(_leftElements);
    for (Todo todo in _todoList) {
      todo.visible = todo.task.left;
    }
  }

  void showCompleted() {
    _setSelectedFilter(_completedElements);
    for (Todo todo in _todoList) {
      todo.visible = todo.task.completed;
    }
  }

  _setSelectedFilter(Element e) {
    _allElements.classes.remove('selected');
    _leftElements.classes.remove('selected');
    _completedElements.classes.remove('selected');
    e.classes.add('selected');
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


