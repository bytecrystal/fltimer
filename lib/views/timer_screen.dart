import 'package:flipclock/state/app_state.dart';
import 'package:flipclock/views/icon_bar.dart';
import 'package:flipclock/views/my_app_bar.dart';
import 'package:flipclock/views/widget/clock/flip_clock.dart';
import 'package:flipclock/views/widget/clock/flip_countdown_clock.dart';
import 'package:flipclock/views/widget/flip_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});


  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  double iconSize = 30;
  final GlobalKey _timeContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildFlipClock(AppState appState) {
      Color clockBgColor = Color(appState.userConfig.clock.bgColor);
      Color clockDigitColor = Color(appState.userConfig.clock.color);
      Color clockHingeColor = Color(appState.userConfig.clock.hingeColor);
      Color clockBorderColor = Color(appState.userConfig.clock.borderColor);
      Color clockSeparatorColor = Color(appState.userConfig.clock.separatorColor);
      return Container(
        alignment:
        Alignment.center,
        key: _timeContainerKey,
        padding: const EdgeInsets.all(5.0),
        child: FlipClock(
          digitSize: appState.userConfig.clock.digitSize,
          width: appState.userConfig.clock.cardWidth,
          height: appState.userConfig.clock.cardHeight,
          digitColor: clockDigitColor,
          separatorWidth: 40.0,
          backgroundColor: clockBgColor,
          separatorColor: clockSeparatorColor,
          borderColor: clockBorderColor,
          hingeColor: clockHingeColor,
          showSeconds: true,
          showBorder: true,
          hingeWidth: 0.8,
          // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
      );
  }

  Widget _buildFlipTimer(AppState appState) {
    Color clockBgColor = Color(appState.userConfig.clock.bgColor);
    Color clockDigitColor = Color(appState.userConfig.clock.color);
    Color clockHingeColor = Color(appState.userConfig.clock.hingeColor);
    Color clockBorderColor = Color(appState.userConfig.clock.borderColor);
    Color clockSeparatorColor = Color(appState.userConfig.clock.separatorColor);
    return Container(
      alignment: Alignment.center,
      // key: timerInfo.timeWidgetKey,
      // decoration: const BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
      // ),
      padding: const EdgeInsets.all(10.0),
      child: FlipCountdownClock(
        digitSize: appState.userConfig.clock.digitSize,
        width: appState.userConfig.clock.cardWidth,
        height: appState.userConfig.clock.cardHeight,
        digitColor: clockDigitColor,
        separatorWidth: 40.0,
        backgroundColor: clockBgColor,
        separatorColor: clockSeparatorColor,
        borderColor: clockBorderColor,
        hingeColor: clockHingeColor,
        showBorder: true,
        hingeWidth: 0.8,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        flipCurve: FlipWidget.bounceFastFlip,
        flipDirection: AxisDirection.down,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {

      return Scaffold(
        backgroundColor: Color(appState.userConfig.appBgColor),
        // 创建一个可拖动的自定义标题栏
        appBar: appState.userConfig.showHeader
            ? const PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: MyAppBar()
              )
            : null,
        body: GestureDetector(
          onDoubleTap: () => {
            appState.toggleWindowSizeWhereDoubleClick(_timeContainerKey)
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Listener(
              onPointerDown: (PointerDownEvent event) =>
                  windowManager.startDragging(), // 当鼠标按下时开始拖拽
              child:
                appState.userConfig.clock.type == 'clock' ? _buildFlipClock(appState) : _buildFlipTimer(appState),
            ),
                if (appState.userConfig.showIconButton)
                  IconBar(iconSize: iconSize)
              ],
            ),
          ),
        ),
      );
    });
  }
}
