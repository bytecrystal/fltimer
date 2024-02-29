
import 'package:flipclock/service/local_storage_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'use_config.g.dart';

@JsonSerializable()
class UserConfig {
  ClockModel clock;
  HeadTitleModel headTitle;
  double windowWidth;
  double windowHeight;

  bool showIconButton;
  bool showHeader;

  int appBgColor = 0xFFFFFFFF;

  void setShowHeader(bool showHeader) {
    if (this.showHeader != showHeader) {
      this.showHeader = showHeader;
      LocalStorageService().setUserConfig(this);
    }
  }

  void setShowIconButton(bool showIconButton) {
    if (this.showIconButton != showIconButton) {
      this.showIconButton = showIconButton;
      LocalStorageService().setUserConfig(this);
    }
  }

  UserConfig({
    required this.clock,
    required this.headTitle,
    required this.windowWidth,
    required this.windowHeight,
    required this.showIconButton,
    required this.showHeader,
    required this.appBgColor
  });

  static UserConfig defaultConfig() {
    return UserConfig(
      clock: ClockModel(bgColor: 0xFF000000, color: 0xFFFFFFFF, digitSize: 54.0, cardWidth: 54.0, cardHeight: 84.0),
      headTitle: HeadTitleModel(bgColor: 0xFF000000, color: 0xFFFFFFFF),
      windowWidth: 585,
      windowHeight: 280,
      showIconButton: true,
      showHeader: true,
      appBgColor: 0xFFFFFFFF
    );
  }

  factory UserConfig.fromJson(Map<String, dynamic> json) => _$UserConfigFromJson(json);

  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

}

@JsonSerializable()
class ClockModel {
  int bgColor;
  int color;
  double digitSize;
  String type = 'timer';
  double cardWidth;
  double cardHeight;

  ClockModel({
    required this.bgColor,
    required this.color,
    required this.digitSize,
    required this.cardWidth,
    required this.cardHeight
  });

  factory ClockModel.fromJson(Map<String, dynamic> json) => _$ClockModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClockModelToJson(this);
}

@JsonSerializable()
class HeadTitleModel {
  int bgColor;
  int color;
  String title = '长路不必问归程';

  HeadTitleModel({required this.bgColor, required this.color});

  factory HeadTitleModel.fromJson(Map<String, dynamic> json) => _$HeadTitleModelFromJson(json);

  Map<String, dynamic> toJson() => _$HeadTitleModelToJson(this);
}
