part of todo_mvc_app;

class TodoApp implements ActionReactionApi {
  DomainSession session;
  Tasks tasks;

  Todos _todos;
  Element _main = query('#main');
  InputElement _completeAll = query('#complete-all');
  Element _footer = query('#footer');
  Element _leftCount = query('#left-count');
  Element _clearCompleted = query('#clear-completed');

  TodoApp(TodoModels domain) {
    session = domain.newSession();
    domain.startActionReaction(this);
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = model.getEntry('Task');

    _todos = new Todos(this);
    //load todos
    String json = window.localStorage['todos'];
    if (json != null) {
      tasks.fromJson(parse(json));
      for (Task task in tasks) {
        _todos.add(task);
      }
      _updateFooter();
    }

    InputElement newTodo = query('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          newTodo.value = '';
          new AddAction(session, tasks, task).doit();
        }
      }
    });

    _completeAll.onClick.listen((Event e) {
      var transaction = new Transaction('complete-all', session);
      if (tasks.left.length == 0) {
        for (Task task in tasks) {
          transaction.add(
              new SetAttributeAction(session, task, 'completed', false));
        }
      } else {
        for (Task task in tasks.left) {
          transaction.add(
              new SetAttributeAction(session, task, 'completed', true));
        }
      }
      transaction.doit();
    });

    _clearCompleted.onClick.listen((MouseEvent e) {
      var transaction = new Transaction('clear-completed', session);
      for (Task task in tasks.completed) {
        transaction.add(
            new RemoveAction(session, tasks.completed, task));
      }
      transaction.doit();
    });
  }

  _save() {
    window.localStorage['todos'] = stringify(tasks.toJson());
  }

  _updateFooter() {
    var display = tasks.length == 0 ? 'none' : 'block';
    _completeAll.style.display = display;
    _main.style.display = display;
    _footer.style.display = display;
    // update counts
    var completedLength = tasks.completed.length;
    var leftLength = tasks.left.length;
    _completeAll.checked = (completedLength == tasks.length);
    _leftCount.innerHtml =
        '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
    if (completedLength == 0) {
      _clearCompleted.style.display = 'none';
    } else {
      _clearCompleted.style.display = 'block';
      _clearCompleted.text = 'Clear completed (${tasks.completed.length})';
    }
  }

  react(ActionApi action) {
    updateTodo(SetAttributeAction action) {
      if (action.property == 'completed') {
        _todos.complete(action.entity);
      }
    }

    if (action is Transaction) {
      for (var transactionAction in action.past.actions) {
        if (transactionAction is SetAttributeAction) {
          updateTodo(transactionAction);
        } else if (transactionAction is RemoveAction) {
          _todos.remove(transactionAction.entity);
        }
      }
    } else if (action is AddAction) {
      _todos.add(action.entity);
    } else if (action is SetAttributeAction) {
      updateTodo(action);
    } else if (action is RemoveAction) {
      _todos.remove(action.entity);
    }
    _updateFooter();
    _save();
  }
}

