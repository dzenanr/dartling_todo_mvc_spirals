part of todo_mvc_app;

class TodoApp {
  TodoModels domain;
  DomainSession session;
  Tasks _tasks;

  Todos _todos;
  Element _main = query('#main');
  Element _footer = query('#footer');
  Element _leftCount = query('#left-count');

  TodoApp(this.domain) {
    session = domain.newSession();
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    _tasks = model.tasks;

    _todos = new Todos(this);
    //load todos
    String json = window.localStorage['todos'];
    if (json != null) {
      _tasks.fromJson(parse(json));
      for (Task task in _tasks) {
        _todos.add(task);
      }
      updateFooter();
    }

    InputElement newTodo = query('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(_tasks.concept);
          task.title = title;
          newTodo.value = '';
          new AddAction(session, _tasks, task).doit();
        }
      }
    });
  }

  save() {
    window.localStorage['todos'] = stringify(_tasks.toJson());
  }

  updateFooter() {
    var display = _tasks.length == 0 ? 'none' : 'block';
    _main.style.display = display;
    _footer.style.display = display;
    // update counts
    var completedLength = _tasks.completed.length;
    var leftLength = _tasks.left.length;
    _leftCount.innerHtml =
        '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
  }
}

