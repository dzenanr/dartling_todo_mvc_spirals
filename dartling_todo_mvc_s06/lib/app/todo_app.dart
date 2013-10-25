part of todo_mvc_app;

class TodoApp {
  TodoModels domain;
  DomainSession session;
  Tasks tasks;

  Header _header;
  Element _main = querySelector('#main');
  Todos _todos;
  Element _errors = querySelector('#errors');
  Footer footer;

  TodoApp(this.domain) {
    session = domain.newSession();
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = model.tasks;

    _header = new Header(this);
    _todos = new Todos(this);
    footer = new Footer(this, _todos);

    _load();
  }

  _load() {
    String json = window.localStorage['todos'];
    if (json != null) {
      tasks.fromJson(JSON.decode(json));
      for (Task task in tasks) {
        _todos.add(task);
      }
    }
    updateDisplay();
  }

  save() {
    window.localStorage['todos'] = JSON.encode(tasks.toJson());
  }

  possibleErrors() {
    _errors.innerHtml = '<p>${tasks.errors.toString()}</p>';
    tasks.errors.clear();
  }

  updateDisplay() {
    var display = tasks.length == 0 ? 'none' : 'block';
    _main.style.display = display;
    _header.updateDisplay();
    footer.updateDisplay();
    possibleErrors();
  }
}

