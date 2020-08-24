import 'dart:collection';

import 'package:flutter/cupertino.dart';

class Task{
  final String name;
  bool isDone = false;

  Task({@required this.name, @required this.isDone});

  void toggleDone(){
    isDone = !isDone;
  }
}

class TaskData extends ChangeNotifier{
  List<Task> _tasks = [
    Task(name: "Graduate", isDone: false),
    Task(name: "Get a job", isDone: false),
    Task(name: "Get married", isDone: false),
  ];

  UnmodifiableListView<Task> get tasks{
    return  UnmodifiableListView(_tasks);
  }

  int get taskCount{
    return _tasks.length;
  }

  void addTask(String title){
    _tasks.add(Task(name: title, isDone: false));
    notifyListeners();
  }
  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}