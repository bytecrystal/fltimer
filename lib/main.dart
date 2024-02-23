import 'package:flipclock/views/TimerScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

Future<bool> _loadShowAppBar() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? showAppBar = prefs.getBool('showAppBar');
  if (showAppBar == null) {
    return false;
  }
  return showAppBar;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  bool showAppBar = await _loadShowAppBar();
  double height = 280;
  if (!showAppBar) {
    height = height - kToolbarHeight;
  }

  WindowOptions windowOptions = WindowOptions(
    size: Size(580, height),
    // backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    // minimumSize: Size(500, 160),
    maximumSize: Size(600, 280),
  );
  // 确保窗口创建后再显示

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAlwaysOnTop(true);
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: ClockScreen(),
      home: TimerScreen(key: const Key("Timer"), duration: Duration(minutes: 30))
    );
  }
}
