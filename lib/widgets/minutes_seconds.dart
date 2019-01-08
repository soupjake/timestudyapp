import 'package:flutter/material.dart';
import 'package:timestudyapp/models/elapsed_time.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class MinutesAndSeconds extends StatefulWidget {
  final double fontSize;

  MinutesAndSeconds({this.fontSize});

  MinutesAndSecondsState createState() => new MinutesAndSecondsState();
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  int minutes;
  int seconds;

  @override
  void initState() {
    minutes = 0;
    seconds = 0;
    StudyViewModel.timerListeners.add(onTick);
    super.initState();
  }

  @override
  void dispose(){
    StudyViewModel.timerListeners.remove(onTick);
    super.dispose();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return Text(minutesStr + ':' + secondsStr + ':',
        style: TextStyle(fontSize: widget.fontSize));
  }
}
