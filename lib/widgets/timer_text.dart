import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timestudyapp/models/elapsed_time.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';
import 'package:timestudyapp/widgets/hundreds.dart';
import 'package:timestudyapp/widgets/minutes_seconds.dart';

class TimerText extends StatefulWidget {
  final double fontSize;

  TimerText({this.fontSize});

  TimerTextState createState() => new TimerTextState();
}

class TimerTextState extends State<TimerText> {
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(Duration(milliseconds: 30), callback);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != StudyViewModel.stopwatch.elapsedMilliseconds) {
      milliseconds = StudyViewModel.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in StudyViewModel.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          MinutesAndSeconds(fontSize: widget.fontSize),
          Hundreds(fontSize: widget.fontSize), 
      ],
    );
  }
}