import 'package:flipclock/service/preferences_service.dart';
import 'package:flipclock/state/time_info.dart';
import 'package:flipclock/views/timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  PreferencesService prefs = PreferencesService();

  bool showAppBar = await prefs.loadShowAppBar();
  double height = 280;
  if (!showAppBar) {
    height = height - kToolbarHeight;
  }

  WindowOptions windowOptions = WindowOptions(
    size: Size(580, height),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    // minimumSize: Size(500, 160),
    maximumSize: const Size(600, 280),
  );
  // 确保窗口创建后再显示

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAlwaysOnTop(true);
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    return ChangeNotifierProvider(
      create: (context) => TimerInfo(const Duration(minutes: 30)),
      child: MaterialApp(
          title: 'Digital Clock',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: ClockScreen(),
          home: const TimerScreen()
      ),
    );
    // return MaterialApp(
    //     title: 'Digital Clock',
    //     theme: ThemeData(
    //     primarySwatch: Colors.blue,
    // ),
    // // home: ClockScreen(),
    // home: TimerScreen(key: const Key("Timer"), duration: Duration(minutes: 30))
  }
}
