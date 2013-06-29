part of todo_mvc_app;

class TodoApp implements ActionReactionApi {
  DomainSession session;
  Tasks tasks;

  Todos _todos;
  Element _main = query('#main');
  Element _footer = query('#footer');
  Element _leftCount = query('#left-count');

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
  }

  _save() {
    window.localStorage['todos'] = stringify(tasks.toJson());
  }

  _updateFooter() {
    var display = tasks.length == 0 ? 'none' : 'block';
    _main.style.display = display;
    _footer.style.display = display;
    // update counts
    var completedLength = tasks.completed.length;
    var leftLength = tasks.left.length;
    _leftCount.innerHtml =
        '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
  }

  react(ActionApi action) {
    if (action is AddAction) {
      _todos.add(action.entity);
    } else if (action is SetAttributeAction) {
      _todos.complete(action.entity);
    }
    _updateFooter();
    _save();
  }
}

