part of todo_mvc_app;

class Todo {
  Element element;

  Todo(Task task) {
    element = new Element.html('''
        <li>      
        <label id='title'>${task.title}</label>
      </li>
    ''');
  }
}
