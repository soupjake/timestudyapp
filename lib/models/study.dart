import 'package:timestudyapp/models/task.dart';

class Study {
  String name;
  List<Task> tasks;

  Study({this.name, this.tasks});

  factory Study.fromJson(Map<String, dynamic> json) {
    var tasksList = json['tasks'] as List;

    return Study(
        name: json['name'],
        tasks: tasksList.map((i) => Task.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() => {'name': name, 'tasks': tasks};
}
