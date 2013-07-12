part of todo_mvc_app;

class TodoApp implements ActionReactionApi, PastReactionApi {
  Tasks _tasks;

  Todos _todos;
  Element _undo = query('#undo');
  Element _redo = query('#redo');
  Element _main = query('#main');
  InputElement _completeAll = query('#complete-all');
  Element _footer = query('#footer');
  Element _leftCount = query('#left-count');
  Element _clearCompleted = query('#clear-completed');
  Element _errors = query('#errors');

  TodoApp(TodoModels domain) {
    DomainSession session = domain.newSession();
    domain.startActionReaction(this);
    session.past.startPastReaction(this);
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    _tasks = model.getEntry('Task');

    _todos = new Todos(session, _tasks);
    //load todos
    String json = window.localStorage['todos'];
    if (json != null) {
      _tasks.fromJson(parse(json));
      for (Task task in _tasks) {
        _todos.add(task);
      }
      _updateFooter();
    }

    _undo.style.display = 'none';
    _undo.onClick.listen((MouseEvent e) {
      session.past.undo();
    });

    _redo.style.display = 'none';
    _redo.onClick.listen((MouseEvent e) {
      session.past.redo();
    });

    InputElement newTodo = query('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(_tasks.concept);
          task.title = title;
          newTodo.value = '';
          new AddAction(session, _tasks, task).doit();
          _possibleErrors();
        }
      }
    });

    _completeAll.onClick.listen((Event e) {
      var transaction = new Transaction('complete-all', session);
      if (_tasks.left.length == 0) {
        for (Task task in _tasks) {
          transaction.add(
              new SetAttributeAction(session, task, 'completed', false));
        }
      } else {
        for (Task task in _tasks.left) {
          transaction.add(
              new SetAttributeAction(session, task, 'completed', true));
        }
      }
      transaction.doit();
    });

    _clearCompleted.onClick.listen((MouseEvent e) {
      var transaction = new Transaction('clear-completed', session);
      for (Task task in _tasks.completed) {
        transaction.add(
            new RemoveAction(session, _tasks.completed, task));
      }
      transaction.doit();
    });
  }

  _save() {
    window.localStorage['todos'] = stringify(_tasks.toJson());
  }

  _possibleErrors() {
    _errors.innerHtml = '<p>${_tasks.errors.toString()}</p>';
    _tasks.errors.clear();
  }

  _updateFooter() {
    var display = _tasks.length == 0 ? 'none' : 'block';
    _completeAll.style.display = display;
    _main.style.display = display;
    _footer.style.display = display;

    // update counts
    var completedLength = _tasks.completed.length;
    var leftLength = _tasks.left.length;
    _completeAll.checked = (completedLength == _tasks.length);
    _leftCount.innerHtml =
        '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
    if (completedLength == 0) {
      _clearCompleted.style.display = 'none';
    } else {
      _clearCompleted.style.display = 'block';
      _clearCompleted.text = 'Clear completed (${_tasks.completed.length})';
    }

    _possibleErrors();
  }

  react(ActionApi action) {
    updateTodo(SetAttributeAction action) {
      if (action.property == 'completed') {
        _todos.complete(action.entity);
      } else if (action.property == 'title') {
        _todos.retitle(action.entity);
      }
    }

    if (action is Transaction) {
      for (var transactionAction in action.past.actions) {
        if (transactionAction is SetAttributeAction) {
          updateTodo(transactionAction);
        } else if (transactionAction is RemoveAction) {
          if (transactionAction.undone) {
            _todos.add(transactionAction.entity);
          } else {
            _todos.remove(transactionAction.entity);
          }
        }
      }
    } else if (action is AddAction) {
      if (action.undone) {
        _todos.remove(action.entity);
      } else {
        _todos.add(action.entity);
      }
    } else if (action is RemoveAction) {
      if (action.undone) {
        _todos.add(action.entity);
      } else {
        _todos.remove(action.entity);
      }
    } else if (action is SetAttributeAction) {
      updateTodo(action);
    }

    _updateFooter();
    _save();
  }

  reactCannotUndo() {
    _undo.style.display = 'none';
  }

  reactCanUndo() {
    _undo.style.display = 'block';
  }

  reactCanRedo() {
    _redo.style.display = 'block';
  }

  reactCannotRedo() {
    _redo.style.display = 'none';
  }
}

