part of todo_mvc_app;

class Todo {
  Task _task;

  Todo(this._task);

  Element create() {
    var _todo = new Element.html('''
      <li>      
        <label id='title'>${_task.title}</label>
      </li>
    ''');
    return _todo;
  }
}
