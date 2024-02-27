
import 'package:flipclock/service/local_storage_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'use_config.g.dart';

@JsonSerializable()
class UserConfig {
  ClockModel clock;
  HeadTitleModel headTitle;
  double windowWidth;
  double windowHeight;
  double timeWidth;
  double timeHeight;
  bool showIconButton;
  bool showHeader;

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
    required this.timeWidth,
    required this.timeHeight,
    required this.showIconButton,
    required this.showHeader
  });

  static UserConfig defaultConfig() {
    return UserConfig(
      clock: ClockModel(bgColor: 0xFF000000, color: 0xFFFFFFFF),
      headTitle: HeadTitleModel(bgColor: 0xFF000000, color: 0xFFFFFFFF),
      windowWidth: 580,
      windowHeight: 280,
      timeWidth: 54,
      timeHeight: 84,
      showIconButton: true,
      showHeader: true
    );
  }

  factory UserConfig.fromJson(Map<String, dynamic> json) => _$UserConfigFromJson(json);

  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

}

@JsonSerializable()
class ClockModel {
  int bgColor;
  int color;
  String type = 'timer';

  ClockModel({required this.bgColor, required this.color});

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
