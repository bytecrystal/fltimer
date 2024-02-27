import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/time_info.dart';
import 'flip_clock_builder.dart';

/// FlipCountdownClock display a countdown flip clock.
///
/// Dispaly a row of [FlipWidget] to show the countdown digits,
/// this digits are refreshed by a stream of time left [Duration] instances,
/// Since FlipWidget only animate changes, only digits that actually
/// change between seconds are flipped.
///
/// Most constructor parameters are required to define digits appearance,
/// some parameters are optional, configuring flip panel appearance.
class FlipCountdownClock extends StatelessWidget {
  /// FlipCountdownClock constructor.
  ///
  /// Parameters define clock digits and flip panel appearance.
  /// - flipDirection defaults to AxisDirection.up.
  /// - flipCurve defaults to null, that will deliver FlipWidget.defaultFlip.
  /// - digitColor and separatorColor defaults to colorScheme.onPrimary.
  /// - backgroundColor defauts to colorScheme.primary.
  /// - separatorWidth defaults to width / 3.
  /// - separatorColor defaults to colorScheme.onPrimary.
  /// - separatorBackground defaults to null (transparent).
  /// - showBorder can be set or defaults to true if boderColor or borderWidth is set
  /// - borderWidth defaults to 1.0 when a borderColor is set
  /// - borderColor defaults to colorScheme.onPrimary when a width is set.
  /// - borderRadius defaults to Radius.circular(4.0)
  /// - digitSpacing defaults to horizontal: 2.0
  /// - hingeWidth defaults to 0.8
  /// - hindeLength defaults to CrossAxis size
  /// - hingeColor defaults to null (transparent)
  FlipCountdownClock({super.key,
    required double digitSize,
    required double width,
    required double height,
    AxisDirection flipDirection = AxisDirection.up,
    Curve? flipCurve,
    Color? digitColor,
    Color? backgroundColor,
    double? separatorWidth,
    Color? separatorColor,
    Color? separatorBackgroundColor,
    bool? showBorder,
    double? borderWidth,
    Color? borderColor,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    double hingeWidth = 0.8,
    double? hingeLength,
    Color? hingeColor,
    EdgeInsets digitSpacing = const EdgeInsets.symmetric(horizontal: 2.0), this.onDone,
  })  :
        _displayBuilder = FlipClockBuilder(
          digitSize: digitSize,
          width: width,
          height: height,
          flipDirection: flipDirection,
          flipCurve: flipCurve,
          digitColor: digitColor,
          backgroundColor: backgroundColor,
          separatorWidth: separatorWidth ?? width / 3.0,
          separatorColor: separatorColor,
          separatorBackgroundColor: separatorBackgroundColor,
          showBorder: showBorder ?? (borderColor != null || borderWidth != null),
          borderWidth: borderWidth,
          borderColor: borderColor,
          borderRadius: borderRadius,
          hingeWidth: hingeWidth,
          hingeLength: hingeWidth == 0.0
              ? 0.0
              : hingeLength ??
                  (flipDirection == AxisDirection.down || flipDirection == AxisDirection.up ? width : height),
          hingeColor: hingeColor,
          digitSpacing: digitSpacing,
        );

  /// Optional callback when the countdown is done.
  final VoidCallback? onDone;

  /// Builder with common code for all FlipClock types.
  ///
  /// This builder is created with most of my constructor parameters
  final FlipClockBuilder _displayBuilder;


  @override
  Widget build(BuildContext context) {
    TimerInfo timerInfo = Provider.of<TimerInfo>(context, listen: false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (timerInfo.duration.inHours > 0) ...[
          _buildHoursDisplay(timerInfo.durationStream, timerInfo.duration),
          _displayBuilder.buildSeparator(context),
        ],
        _buildMinutesDisplay(timerInfo.durationStream, timerInfo.duration),
        _displayBuilder.buildSeparator(context),
        _buildSecondsDisplay(timerInfo.durationStream, timerInfo.duration),
      ],
    );
  }

  Widget _buildHoursDisplay(Stream<Duration> stream, Duration initValue) => _displayBuilder.buildTimePartDisplay(
    stream.map((time) => time.inHours % 24),
    initValue.inHours % 24,
  );

  Widget _buildMinutesDisplay(Stream<Duration> stream, Duration initValue) => _displayBuilder.buildTimePartDisplay(
    stream.map((time) => time.inMinutes % 60),
    initValue.inMinutes % 60,
  );

  Widget _buildSecondsDisplay(Stream<Duration> stream, Duration initValue) => _displayBuilder.buildTimePartDisplay(
    stream.map((time) => time.inSeconds % 60),
    initValue.inSeconds % 60,
  );

}

