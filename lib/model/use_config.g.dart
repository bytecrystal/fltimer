// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConfig _$UserConfigFromJson(Map<String, dynamic> json) => UserConfig(
      clock: ClockModel.fromJson(json['clock'] as Map<String, dynamic>),
      headTitle:
          HeadTitleModel.fromJson(json['headTitle'] as Map<String, dynamic>),
      windowWidth: (json['windowWidth'] as num).toDouble(),
      windowHeight: (json['windowHeight'] as num).toDouble(),
      showIconButton: json['showIconButton'] as bool,
      showHeader: json['showHeader'] as bool,
      appBgColor: json['appBgColor'] as int,
    );

Map<String, dynamic> _$UserConfigToJson(UserConfig instance) =>
    <String, dynamic>{
      'clock': instance.clock,
      'headTitle': instance.headTitle,
      'windowWidth': instance.windowWidth,
      'windowHeight': instance.windowHeight,
      'showIconButton': instance.showIconButton,
      'showHeader': instance.showHeader,
      'appBgColor': instance.appBgColor,
    };

ClockModel _$ClockModelFromJson(Map<String, dynamic> json) => ClockModel(
      bgColor: json['bgColor'] as int,
      color: json['color'] as int,
      digitSize: (json['digitSize'] as num).toDouble(),
      cardWidth: (json['cardWidth'] as num).toDouble(),
      cardHeight: (json['cardHeight'] as num).toDouble(),
    )..type = json['type'] as String;

Map<String, dynamic> _$ClockModelToJson(ClockModel instance) =>
    <String, dynamic>{
      'bgColor': instance.bgColor,
      'color': instance.color,
      'digitSize': instance.digitSize,
      'type': instance.type,
      'cardWidth': instance.cardWidth,
      'cardHeight': instance.cardHeight,
    };

HeadTitleModel _$HeadTitleModelFromJson(Map<String, dynamic> json) =>
    HeadTitleModel(
      bgColor: json['bgColor'] as int,
      color: json['color'] as int,
    )..title = json['title'] as String;

Map<String, dynamic> _$HeadTitleModelToJson(HeadTitleModel instance) =>
    <String, dynamic>{
      'bgColor': instance.bgColor,
      'color': instance.color,
      'title': instance.title,
    };
