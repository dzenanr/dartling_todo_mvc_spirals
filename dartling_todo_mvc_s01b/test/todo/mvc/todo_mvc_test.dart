// test/todo/mvc/todo_mvc_test.dart

import "package:test/test.dart";

import "package:dartling/dartling.dart";

import "package:dartling_todo_mvc/dartling_todo_mvc.dart";

testTodoMvc(Repo repo, String domainCode, String modelCode) {
  MvcEntries entries;
  Tasks tasks;
  int length = 0;
  Concept concept;
  group("Testing ${domainCode}.${modelCode}", () {
    setUp(() {
      var models = repo.getDomainModels(domainCode);
      entries = models.getModelEntries(modelCode);
      expect(entries, isNotNull);
      tasks = entries.tasks;
      expect(tasks.length, equals(length));
      concept = tasks.concept;
      expect(concept, isNotNull);
      expect(concept.attributes.toList(), isNot(isEmpty));

      var design = new Task(concept);
      expect(design, isNotNull);
      design.title = 'design a model';
      tasks.add(design);
      expect(tasks.length, equals(++length));

      var json = new Task(concept);
      json.title = 'generate json from the model';
      tasks.add(json);
      expect(tasks.length, equals(++length));

      var generate = new Task(concept);
      generate.title = 'generate code from the json document';
      tasks.add(generate);
      expect(tasks.length, equals(++length));
    });
    tearDown(() {
      tasks.clear();
      expect(tasks.isEmpty, isTrue);
      length = 0;
    });
    test('Empty Entries Test', () {
      entries.clear();
      expect(entries.isEmpty, isTrue);
    });

    test('From Tasks to JSON', () {
      var json = tasks.toJson();
      expect(json, isNotNull);
      print(json);
    });
    test('From Task Model to JSON', () {
      var json = entries.toJson();
      expect(json, isNotNull);
      entries.displayJson();
    });
    test('From JSON to Task Model', () {
      tasks.clear();
      expect(tasks.isEmpty, isTrue);
      entries.fromJsonToData();
      expect(tasks.isEmpty, isFalse);
      tasks.display(title:'From JSON to Task Model');
    });

    test('Add Task Required Title Error', () {
      var task = new Task(concept);
      expect(concept, isNotNull);
      var added = tasks.add(task);
      expect(added, isFalse);
      expect(tasks.length, equals(length));
      expect(tasks.errors.length, equals(1));
      expect(tasks.errors.toList()[0].category, equals('required'));
      tasks.errors.display(title:'Add Task Required Title Error');
    });

    test('Find Task by New Oid', () {
      var oid = new Oid.ts(1345648254063);
      var task = tasks.singleWhereOid(oid);
      expect(task, isNull);
    });
    test('Find Task by Attribute', () {
      var title = 'generate json from the model';
      var task = tasks.firstWhereAttribute('title', title);
      expect(task, isNotNull);
      expect(task.title, equals(title));
    });
    test('Random Task', () {
      var task1 = tasks.random();
      expect(task1, isNotNull);
      task1.display(prefix:'random 1');
      var task2 = tasks.random();
      expect(task2, isNotNull);
      task2.display(prefix:'random 2');
    });

  });
}

testTodoData(TodoRepo todoRepo) {
  testTodoMvc(todoRepo, TodoRepo.todoDomainCode,
      TodoRepo.todoMvcModelCode);
}

void main() {
  var todoRepo = new TodoRepo();
  testTodoData(todoRepo);
}

