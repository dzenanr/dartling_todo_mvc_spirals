part of todo_mvc_app;

class Todo {
  Task task;

  Element element;
  InputElement _completed;

  Todo(TodoApp todoApp, this.task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;
    element = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <input class='completed' type='checkbox'
          ${task.completed ? 'checked' : ''}>
        <label id='title'>${task.title}</label>
        <button class='remove'></button>
      </li>
    ''');

    _completed = element.query('.completed');
    _completed.onClick.listen((MouseEvent e) {
      new SetAttributeAction(session, task, 'completed',
          !task.completed).doit();
    });

    element.query('.remove').onClick.listen((MouseEvent e) {
      var action = new RemoveAction(session, tasks, task).doit();
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
