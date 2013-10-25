part of todo_mvc_app;

class Todos {
  Element _todoList = querySelector('#todo-list');

  Todos(Tasks tasks) {
    InputElement newTodo = querySelector('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          tasks.add(task);
          _add(task);
          newTodo.value = '';
        }
      }
    });
  }

  _add(Task task) {
    var element = new Element.html('''
      <li>      
        <label id='title'>${task.title}</label>
      </li>
    ''');
    _todoList.nodes.add(element);
  }
}


