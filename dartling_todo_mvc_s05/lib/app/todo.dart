part of todo_mvc_app;

class Todo {
  Task task;

  Tasks _tasks;
  DomainSession _session;

  Element _todo;
  InputElement _completed;
  Element _title;

  Todo(TodoApp todoApp, this.task) {
    _session = todoApp.session;
    _tasks = todoApp.tasks;
  }

  Element create() {
    _todo = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='completed' type='checkbox'
            ${task.completed ? 'checked' : ''}>
          <label id='title'>${task.title}</label>
          <button class='remove'></button>
        </div>
        <input class='edit' value='${task.title}'>
      </li>
    ''');

    _completed = _todo.query('.completed');
    _completed.onClick.listen((MouseEvent e) {
      new SetAttributeAction(_session, task, 'completed',
          !task.completed).doit();
    });

    _title = _todo.query('#title');
    InputElement edit = _todo.query('.edit');

    _title.onDoubleClick.listen((MouseEvent e) {
      _todo.classes.add('editing');
      edit.select();
    });

    edit.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var value = edit.value.trim();
        if (value != '') {
          new SetAttributeAction(_session, task, 'title', value).doit();
        }
      }
    });

    _todo.query('.remove').onClick.listen((MouseEvent e) {
      var action = new RemoveAction(_session, _tasks, task).doit();
    });

    return _todo;
  }

  complete(bool completed) {
    _completed.checked = completed;
    if (completed) {
      _todo.classes.add('completed');
    } else {
      _todo.classes.remove('completed');
    }
  }

  retitle(String title) {
    _title.text = title;
    _todo.classes.remove('editing');
  }

  remove() {
    _todo.remove();
  }

  set visible(bool visible) {
    _todo.style.display = visible ? 'block' : 'none';
  }
}
