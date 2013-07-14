part of todo_mvc_app;

class Footer {
  Tasks _tasks;

  Todos _todos;
  Element _footer = query('#footer');
  Element _leftCount = query('#left-count');
  Element _allElements = query('#filter a[href="#/"]');
  Element _leftElements = query('#filter a[href="#/left"]');
  Element _completedElements = query('#filter a[href="#/completed"]');
  Element _clearCompleted = query('#clear-completed');

  Footer(TodoApp todoApp, this._todos) {
    _tasks = todoApp.tasks;
    DomainSession session = todoApp.session;

    window.onHashChange.listen((e) => updateFilter());

    _clearCompleted.onClick.listen((MouseEvent e) {
      var transaction = new Transaction('clear-completed', session);
      for (Task task in _tasks.completed) {
        transaction.add(
            new RemoveAction(session, _tasks.completed, task));
      }
      transaction.doit();
    });
  }

  updateFilter() {
    switch(window.location.hash) {
      case '#/left':
        _showLeft();
        break;
      case '#/completed':
        _showCompleted();
        break;
      default:
        _showAll();
        break;
    }
  }

  _showAll() {
    _setSelectedFilter(_allElements);
    for (Todo todo in _todos) {
      todo.visible = true;
    }
  }

  _showLeft() {
    _setSelectedFilter(_leftElements);
    for (Todo todo in _todos) {
      todo.visible = todo.task.left;
    }
  }

  _showCompleted() {
    _setSelectedFilter(_completedElements);
    for (Todo todo in _todos) {
      todo.visible = todo.task.completed;
    }
  }

  _setSelectedFilter(Element e) {
    _allElements.classes.remove('selected');
    _leftElements.classes.remove('selected');
    _completedElements.classes.remove('selected');
    e.classes.add('selected');
  }

  updateDisplay() {
    var display = _tasks.length == 0 ? 'none' : 'block';
    _footer.style.display = display;

    // update counts
    var completedLength = _tasks.completed.length;
    var leftLength = _tasks.left.length;
    _leftCount.innerHtml =
        '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
    if (completedLength == 0) {
      _clearCompleted.style.display = 'none';
    } else {
      _clearCompleted.style.display = 'block';
      _clearCompleted.text = 'Clear completed (${_tasks.completed.length})';
    }
  }
}