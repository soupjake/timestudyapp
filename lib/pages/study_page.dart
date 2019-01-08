import 'package:flutter/material.dart';
import 'package:timestudyapp/models/study.dart';
import 'package:timestudyapp/models/task.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class StudyPage extends StatefulWidget {
  final String title;
  final int selected;

  StudyPage({this.title, this.selected});

  @override
  State createState() => StudyPageState();
}

class StudyPageState extends State<StudyPage> {
  Study study;
  TextField nameField;
  TextEditingController nameController = new TextEditingController();
  TextField taskNameField;
  TextEditingController taskNameController = new TextEditingController();

  @override
  void initState() {
    nameField = new TextField(
      controller: nameController,
      decoration: InputDecoration(
          labelText: 'Study name'),
    );
    taskNameField = new TextField(
      controller: taskNameController,
      decoration:
          InputDecoration(labelText: 'Task name'),
    );
    if(widget.selected != null) {
      study = StudyViewModel.studies[widget.selected];
      nameController.text = study.name;
    } else {
      study = new Study(
          name: "",
          tasks: new List<Task>()
        );
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Material(
          child: Padding(padding: EdgeInsets.all(16.0), child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 8.0), child: nameField),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Tasks:', style: TextStyle(fontSize: 18.0),),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Add a task'),
                              content: taskNameField,
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Accept'),
                                  onPressed: () {
                                    if(taskNameController.text == ""){
                                      errorDialog(context, 'Please enter a task name!');
                                    } else {
                                    setState(() {
                                      study.tasks.add(new Task(
                                          name: taskNameController.text,
                                          elapsedTime:
                                              StudyViewModel.milliToElapsedString(
                                                  0)));
                                      taskNameController.clear();
                                    });
                                    Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: study.tasks.length,
                  itemBuilder: (context, int index) {
                    return ListTile(
                      title: Text(study.tasks[index].name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            study.tasks.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ), Spacer(),
              Center(
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                child: Text('Save'),
                onPressed: () async {
                  if (nameController.text == "") {
                    errorDialog(context, 'Please enter a study name!');
                  } else {
                    if (study.tasks.length < 1) {
                      errorDialog(context, 'Please add at least one task!');
                    } else {
                      study.name = nameController.text;
                      if (widget.selected != null) {
                        StudyViewModel.studies[widget.selected] = study;
                        await StudyViewModel.saveFile();
                        Navigator.of(context).pop();
                      } else {
                        if (StudyViewModel.checkName(nameController.text)) {
                          errorDialog(context, 'Study name already taken!');
                        } else {
                          StudyViewModel.studies.add(study);
                          await StudyViewModel.saveFile();
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  }
                },
              ))
            ],
          ),
        )));
  }

  void errorDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}
