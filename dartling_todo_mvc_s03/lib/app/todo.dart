part of todo_mvc_app;

class Todo {
  DomainSession _session;
  Task _task;
  Tasks _tasks;

  Element element;
  InputElement _completed;

  Todo(TodoApp todoApp, this._task) {
    _session = todoApp.session;
    _tasks = todoApp.tasks;
    _create();
  }

  _create() {
    element = new Element.html('''
      <li ${_task.completed ? 'class="completed"' : ''}>
        <input class='completed' type='checkbox'
          ${_task.completed ? 'checked' : ''}>
        <label id='title'>${_task.title}</label>
        <button class='remove'></button>
      </li>
    ''');

    _completed = element.query('.completed');
    _completed.onClick.listen((MouseEvent e) {
      new SetAttributeAction(_session, _task, 'completed',
          !_task.completed).doit();
    });

    element.query('.remove').onClick.listen((MouseEvent e) {
      var action = new RemoveAction(_session, _tasks, _task).doit();
    });
  }

  complete(bool completed) {
    _completed.checked = completed;
    if (completed) {
      element.classes.add('completed');
    } else {
      element.classes.remove('completed');
    }
  }

  remove() {
    element.remove();
  }
}
