part of todo_mvc_app;

class Todo {
  Task task;

  Element element;
  InputElement _completed;

  Todo(DomainSession session, this.task) {
    element = new Element.html('''
        <li ${task.completed ? 'class="completed"' : ''}>
        <input class='completed' type='checkbox'
          ${task.completed ? 'checked' : ''}>
        <label id='title'>${task.title}</label>
      </li>
    ''');

    _completed = element.query('.completed');
    _completed.onClick.listen((MouseEvent e) {
      new SetAttributeAction(session, task, 'completed',
          !task.completed).doit();
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
