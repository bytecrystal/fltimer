import 'dart:async';

import 'package:flipclock/views/CountdownScreen.dart';
import 'package:flipclock/views/TimerScreen.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: ClockScreen(),
      home: TimerScreen(key: const Key("Timer"), duration: Duration(minutes: 30))
    );// 目标日期设置为当前时间之后的1天    );
  }
}
