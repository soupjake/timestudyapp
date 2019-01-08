import 'package:flutter/material.dart';
import 'package:timestudyapp/pages/study_page.dart';
import 'package:timestudyapp/pages/timer_page.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController textController = new TextEditingController();
  String filter;

  @override
  void initState() {
    textController.addListener(() {
      setState(() {
        filter = textController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('TimeStudyApp'),
      ),
      body: Material(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: TextField(
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        textController.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                    hintText: "Search...",
                  ),
                  controller: textController,
                )),
            Expanded(
              child: StudyViewModel.studies.length > 0
                  ? ListView.builder(
                      itemCount: StudyViewModel.studies.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (filter == null || filter == "") {
                          return buildRow(context, index);
                        } else {
                          if (StudyViewModel.studies[index].name
                              .toLowerCase()
                              .contains(filter.toLowerCase())) {
                            return buildRow(context, index);
                          } else {
                            return Container();
                          }
                        }
                      },
                    )
                  : Center(
                      child: Text('No studies found!'),
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudyPage(
                        title: 'Add a study',
                        selected: null,
                      )));
        },
      ),
    );
  }

  Widget buildRow(BuildContext context, int index) {
    return ExpansionTile(
      title: Text(StudyViewModel.studies[index].name, style: TextStyle(fontSize: 18.0)),
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: StudyViewModel.studies[index].tasks.length,
          itemBuilder: (context, int taskIndex) {
            return ListTile(
              title: Text(StudyViewModel.studies[index].tasks[taskIndex].name),
              contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
              subtitle: Text(
                  StudyViewModel.studies[index].tasks[taskIndex].elapsedTime),
              trailing: IconButton(
                icon: Icon(
                  Icons.timer
                ),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimerPage(
                              task: StudyViewModel
                                  .studies[index].tasks[taskIndex])));
                },
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit
              ),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudyPage(
                            title: StudyViewModel.studies[index].name,
                            selected: index)));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete
              ),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('Do you wish to delete this study?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Accept'),
                            onPressed: () async {
                              StudyViewModel.studies.removeAt(index);
                              await StudyViewModel.saveFile();
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ],
    );
  }
}
