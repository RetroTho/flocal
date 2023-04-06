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
  int _work = 10;
  int _break = 3;
  int _current = 0;
  bool _started = false;
  bool _paused = false;
  String _task = "";

  void startWorkTimer() {
    const oneSec = Duration(seconds: 1);
    _current = _work;
    _task = "Work!";
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!_paused) {
          if (_current == 0){
            setState(() {
              timer.cancel();
              startBreakTimer();
            });
          }
          else {
            setState(() {
              _current--;
            });
          }
        }
      },
    );
  }

  void startBreakTimer() {
    const oneSec = Duration(seconds: 1);
    _current = _break;
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
            Text(_task),
            Text("$_current"),
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
          ],
        ),
      ),
    );
  }
}