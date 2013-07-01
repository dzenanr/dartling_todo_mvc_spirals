// test/todo/mvc/todo_mvc_gen.dart

import "package:dartling/dartling.dart";

import "package:dartling_todo_mvc/dartling_todo_mvc.dart";

genCode() {
  var repo = new Repo();

  var todoDomain = new Domain("Todo");

  Model todoMvcModel =
      fromJsonToModel(todoMvcModelJson, todoDomain, "Mvc");

  repo.domains.add(todoDomain);

  repo.gen("todo_mvc");
}

initTodoData(TodoRepo todoRepo) {
   var todoModels =
       todoRepo.getDomainModels(TodoRepo.todoDomainCode);

   var todoMvcEntries =
       todoModels.getModelEntries(TodoRepo.todoMvcModelCode);
   initTodoMvc(todoMvcEntries);
   todoMvcEntries.display();
   todoMvcEntries.displayJson();
}

void main() {
  genCode();

  var todoRepo = new TodoRepo();
  initTodoData(todoRepo);
}