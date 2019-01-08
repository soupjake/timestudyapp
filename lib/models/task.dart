class Task {
  String name;
  String elapsedTime;

  Task({this.name, this.elapsedTime});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(name: json['name'], elapsedTime: json['elapsedTime']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'elapsedTime': elapsedTime};
}
