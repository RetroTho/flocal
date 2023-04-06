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
  int _time = 10;
  bool _started = false;
  bool _paused = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!_paused) {
          if (_time == 0){
            setState(() {
              timer.cancel();
            });
          }
          else {
            setState(() {
              _time--;
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
            Text("$_time"),
            ElevatedButton(onPressed: () {
              if (!_started){
                startTimer();
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