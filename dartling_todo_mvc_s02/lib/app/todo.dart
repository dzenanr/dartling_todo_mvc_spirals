part of todo_mvc_app;

class Todo {
  DomainSession _session;
  Task _task;
  Tasks _tasks;

  Element _todo;
  InputElement _completed;

  Todo(TodoApp todoApp, this._task) {
    _session = todoApp.session;
    _tasks = todoApp.tasks;
  }

  Element create() {
    _todo = new Element.html('''
      <li ${_task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='completed' type='checkbox'
            ${_task.completed ? 'checked' : ''}>
          <label id='title'>${_task.title}</label>
        </div>
      </li>
    ''');

    _completed = _todo.query('.completed');
    _completed.onClick.listen((MouseEvent e) {
      new SetAttributeAction(_session, _task, 'completed',
          !_task.completed).doit();
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
}
