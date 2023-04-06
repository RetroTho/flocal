import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Timer _timer = Timer(const Duration(), () {});
  final Widget _playIcon = const Icon(Icons.play_circle);
  final Widget _pauseIcon = const Icon(Icons.pause_circle);
  Widget _buttonIcon = const Icon(Icons.play_circle);
  final int _work = 1500;
  final int _break = 300;
  final int _longBreak = 1200;
  int _current = 0;
  int _sessions = 0;
  bool _started = false;
  bool _paused = false;
  String _task = "";
  String _output = "";

  // formats an amount of seconds into HH:MM:SS format
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

  // starts the timer
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!_paused) {
          if (_current == 0){
            setState(() {
              timer.cancel();
              switchTask();
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

  // sets and starts the timer for a work session
  void startWork() {
    _current = _work;
    _output = formatTime(_current);
    _task = "Work!";
    startTimer();
  }

  // sets and starts the timer for a break or long break
  void startBreak() {
    if ((_sessions % 4) == 0) {
      _current = _longBreak;
    }
    else{
      _current = _break;
    }
    _output = formatTime(_current);
    _task = "Break!";
    startTimer();
  }

  // switches between work and break tasks
  void switchTask() {
    if (_task == "Work!") {
      _sessions++;
      startBreak();
    }
    else {
      startWork();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFF3B3B3B),
      appBar: AppBar(centerTitle: true, title: const Text("Flocal", style: TextStyle(color: Colors.white),),),
      body: SizedBox(
        // sets box width to screen width
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              "Sessions done: $_sessions",
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Text(
              _task,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _output,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 55,
                fontWeight: FontWeight.w100,
              ),
            ),
            IconButton(
              onPressed: () {
                // start, pause, or unpause the timer based on it's current state
                if (!_started){
                  startWork();
                  _started = true;
                  setState(() {_buttonIcon = _pauseIcon;});
                }
                else if (!_paused){
                  _paused = true;
                  setState(() {_buttonIcon = _playIcon;});
                }
                else {
                  _paused = false;
                  setState(() {_buttonIcon = _pauseIcon;});
                }
              },
              icon: _buttonIcon,
              color: Colors.white,
              iconSize: 50,
            ),
            const Spacer(),
            ElevatedButton(
              style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              onPressed: () {
                // skip current task
                _current = 0;
              },
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            ElevatedButton(
              style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              onPressed: () {
                // reset app to inital state
                _task = "";
                _output = "";
                setState(() {
                  _buttonIcon = _playIcon;
                  _sessions = 0;
                });
                _timer.cancel();
                _current = 0;
                _paused = false;
                _started = false;
              },
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
          ],
        ),
      ),
    );
  }
}