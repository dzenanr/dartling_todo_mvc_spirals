
import 'package:dartling_todo_mvc/dartling_todo_mvc.dart';
import 'package:dartling_todo_mvc/dartling_todo_mvc_app.dart';

main() {
  var repo = new TodoRepo();
  TodoModels domain = repo.getDomainModels(TodoRepo.todoDomainCode);
  new TodoApp(domain);
}



