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

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
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
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("$_time"),
          ElevatedButton(onPressed: () {
            startTimer();
          },
          child: const Text("Start")),
        ],
      ),
    );
  }
}