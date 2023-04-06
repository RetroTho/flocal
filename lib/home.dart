import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Timer _timer = Timer(const Duration(), () {});
  final int _work = 1500;
  final int _break = 300;
  int _current = 0;
  int _sessions = 0;
  bool _started = false;
  bool _paused = false;
  String _task = "";
  String _output = "";

  String formatTime(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0){
      return "$minutesStr:$secondsStr";
    }
    else {
      return "$hoursStr:$minutesStr:$secondsStr";
    }
  }

  void startWorkTimer() {
    const oneSec = Duration(seconds: 1);
    _current = _work;
    _output = formatTime(_current);
    _task = "Work!";
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!_paused) {
          if (_current == 0){
            setState(() {
              timer.cancel();
              _sessions++;
              startBreakTimer();
            });
          }
          else {
            setState(() {
              _current--;
              _output = formatTime(_current);
            });
          }
        }
      },
    );
  }

  void startBreakTimer() {
    const oneSec = Duration(seconds: 1);
    _current = _break;
    _output = formatTime(_current);
    _task = "Break!";
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!_paused) {
          if (_current == 0){
            setState(() {
              timer.cancel();
              startWorkTimer();
            });
          }
          else {
            setState(() {
              _current--;
              _output = formatTime(_current);
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flocal"),
      ),
      body: SizedBox(
        // sets box width to screen width
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Sessions done: $_sessions"),
            Text(_task),
            Text(_output),
            ElevatedButton(onPressed: () {
              if (!_started){
                startWorkTimer();
                _started = true;
              }
              else if (!_paused){
                _paused = true;
              }
              else {
                _paused = false;
              }
            },
            child: const Text("Start/Stop")),
            ElevatedButton(onPressed: () {
              _current = 0;
            },
            child: const Text("Skip")),
          ],
        ),
      ),
    );
  }
}