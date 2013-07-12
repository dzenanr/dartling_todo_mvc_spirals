
import 'package:dartling_todo_mvc/dartling_todo_mvc.dart';
import 'package:dartling_todo_mvc/dartling_todo_mvc_app.dart';

main() {
  var repo = new TodoRepo();
  var domain = repo.getDomainModels('Todo');
  var model = domain.getModelEntries('Mvc');
  new TodoApp(model.tasks);
}



