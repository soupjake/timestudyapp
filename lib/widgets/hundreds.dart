import 'package:flutter/material.dart';
import 'package:timestudyapp/models/elapsed_time.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class Hundreds extends StatefulWidget {
  final double fontSize;

  Hundreds({this.fontSize});

  HundredsState createState() => new HundredsState();
}

class HundredsState extends State<Hundreds> {

  int hundreds;

  @override
  void initState() {
    hundreds = 0;
    StudyViewModel.timerListeners.add(onTick);
    super.initState();
  }

    @override
  void dispose(){
    StudyViewModel.timerListeners.remove(onTick);
    super.dispose();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return Text(hundredsStr, style: TextStyle(fontSize: widget.fontSize),);
  }
}