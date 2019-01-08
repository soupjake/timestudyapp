import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timestudyapp/models/elapsed_time.dart';
import 'package:timestudyapp/models/study.dart';
import 'package:path_provider/path_provider.dart';

class StudyViewModel {
  static List<Study> studies = new List<Study>();
  static List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  static Stopwatch stopwatch = new Stopwatch();

  static Future load() async {
    try {
      File file = await getFile();
      String studiesJson = await file.readAsString();
      if(studiesJson != null) {
        List studiesParsed = json.decode(studiesJson);
        studies = studiesParsed.map((i) => Study.fromJson(i)).toList();
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/studies.json');
  }

  static Future saveFile() async {
    File file = await getFile();
    file.writeAsString(json.encode(studies));
  }

  static bool checkName(String name) {
    bool match = false;
    for(int i = 0; i < studies.length; i++) {
      if(studies[i].name == name){
        match = true;
        break;
      }
    }
    return match;
  }

  static String milliToElapsedString(int milliseconds) {
    final int hundreds = (milliseconds / 10).truncate();
    final int seconds = (hundreds / 100).truncate();
    final int minutes = (seconds / 60).truncate();
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return minutesStr + ':' + secondsStr + ':' + hundredsStr;
  }
}