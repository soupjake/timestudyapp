import 'package:flutter/material.dart';
import 'package:timestudyapp/models/task.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';
import 'package:timestudyapp/widgets/timer_text.dart';

class TimerPage extends StatefulWidget {
  final Task task;

  TimerPage({this.task});

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  bool disable = false;
  TimerText timerText;

  @override
  void initState() {
    StudyViewModel.stopwatch = new Stopwatch();
    timerText = new TimerText(
      fontSize: 48.0,
    );
    super.initState();
  }

  @override
  void dispose() {
    StudyViewModel.stopwatch = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.task.name),
        ),
        body: Material(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: timerText,
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: disable
                          ? null
                          : () {
                              setState(() {
                                StudyViewModel.stopwatch.reset();
                              });
                            },
                    ),
                    IconButton(
                      iconSize: 52.0,
                      icon: StudyViewModel.stopwatch.isRunning
                          ? Icon(Icons.pause_circle_outline)
                          : Icon(Icons.play_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (StudyViewModel.stopwatch.isRunning) {
                            StudyViewModel.stopwatch.stop();
                            disable = false;
                          } else {
                            StudyViewModel.stopwatch.start();
                            disable = true;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: disable
                          ? null
                          : () async {
                              widget.task.elapsedTime =
                                  StudyViewModel.milliToElapsedString(
                                      StudyViewModel
                                          .stopwatch.elapsedMilliseconds);
                              await StudyViewModel.saveFile();
                              Navigator.of(context).pop();
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
