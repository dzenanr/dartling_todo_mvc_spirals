part of todo_mvc_app;

class TodoApp {
  TodoModels domain;
  DomainSession session;
  Tasks tasks;

  Header _header;
  Element _main = query('#main');
  Todos _todos;
  Element _errors = query('#errors');
  Footer _footer;

  TodoApp(this.domain) {
    session = domain.newSession();
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = model.tasks;

    _header = new Header(this);
    _todos = new Todos(this);
    _footer = new Footer(this, _todos);

    InputElement newTodo = query('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          newTodo.value = '';
          new AddAction(session, tasks, task).doit();
          _possibleErrors();
        }
      }
    });

    _load();
  }

  _load() {
    String json = window.localStorage['todos'];
    if (json != null) {
      tasks.fromJson(parse(json));
      for (Task task in tasks) {
        _todos.add(task);
      }
    }
    updateDisplay();
  }

  save() {
    window.localStorage['todos'] = stringify(tasks.toJson());
  }

  _possibleErrors() {
    _errors.innerHtml = '<p>${tasks.errors.toString()}</p>';
    tasks.errors.clear();
  }

  updateDisplay() {
    var display = tasks.length == 0 ? 'none' : 'block';
    _main.style.display = display;
    _header.updateDisplay();
    _footer.updateDisplay();
    _possibleErrors();
  }
}

