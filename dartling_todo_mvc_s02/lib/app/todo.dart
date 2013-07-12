part of todo_mvc_app;

class Todo {
  DomainSession _session;
  Task _task;

  Element element;
  InputElement _completed;

  Todo(TodoApp todoApp, this._task) {
    _session = todoApp.session;
    _create();
  }

  _create() {
    element = new Element.html('''
      <li ${_task.completed ? 'class="completed"' : ''}>
        <input class='completed' type='checkbox'
          ${_task.completed ? 'checked' : ''}>
        <label id='title'>${_task.title}</label>
      </li>
    ''');

    _completed = element.query('.completed');
    _completed.onClick.listen((MouseEvent e) {
      new SetAttributeAction(_session, _task, 'completed',
          !_task.completed).doit();
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
}
