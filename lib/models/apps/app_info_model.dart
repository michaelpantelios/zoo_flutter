import 'package:flutter/material.dart';

enum AppType { full, popup, dropdown }

class AppInfoModel {
  final int appId;
  final String appName;
  final AppType appType;
  final IconData iconPath;
  final Widget appWidget;
  final Size size;

  AppInfoModel({
    @required this.appId,
    @required this.appName,
    this.appType,
    @required this.iconPath,
    @required this.appWidget,
    this.size,
  });

  @override
  String toString() {
    return "appId: ${appId}, appName: ${appName}, appType: ${appType},  appWidget: ${appWidget}, size: ${size}";
  }
}
