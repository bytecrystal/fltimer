
import 'package:flipclock/views/widget/clock/flip_clock.dart';
import 'package:flipclock/views/widget/clock/flip_countdown_clock.dart';
import 'package:flipclock/views/widget/flip_widget.dart';
import 'package:flutter/material.dart';

import '../state/time_info.dart';

class MyFlipClock extends StatelessWidget {
  final TimerInfo timerInfo;

  const MyFlipClock({
    super.key,
    required this.timerInfo
  });
  // final double itemWidth = 54.0;
  //
  // final double itemHeight = 84.0;


  Widget _flipCountdown(ColorScheme colors) =>
      Container(
        key: timerInfo.timeWidgetKey,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(24.0),
        child: FlipCountdownClock(
          digitSize: timerInfo.timeWidth,
          width: timerInfo.timeWidth,
          height: timerInfo.timeHeight,
          separatorWidth: 40.0,
          digitColor: colors.surface,
          backgroundColor: colors.primary,
          separatorColor: colors.primary,
          borderColor: colors.primary,
          hingeColor: colors.surface,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          digitSpacing: const EdgeInsets.symmetric(horizontal: 3.0),
          flipDirection: AxisDirection.down,
          flipCurve: FlipWidget.bounceFastFlip,
          onDone: () => print('Buzzzz!'),
        ),
      );

  Widget _flipClock(ColorScheme colors) =>
      Container(
        alignment: Alignment.center,
        key: timerInfo.timeWidgetKey,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.all(10.0),
        child: FlipClock(
          // digitSize: itemWidth + ((itemHeight - itemWidth).abs() / 2),
          digitSize: timerInfo.timeWidth,
          width: timerInfo.timeWidth,
          height: timerInfo.timeHeight,
          // digitColor: Colors.grey[300]!,
          separatorWidth: 40.0,
          backgroundColor: colors.primary,
          separatorColor: colors.primary,
          borderColor: colors.primary,
          hingeColor: Colors.black,
          showSeconds: true,
          showBorder: true,
          hingeWidth: 0.8,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: timerInfo.timeColor,
      ),
    );

    ColorScheme colorScheme = theme.colorScheme;
    return timerInfo.displayCurrentTime ? _flipClock(colorScheme) : _flipCountdown(colorScheme);
  }
}
