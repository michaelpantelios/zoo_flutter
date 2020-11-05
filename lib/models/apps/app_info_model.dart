import 'package:flutter/material.dart';

  enum AppType {full, popup, dropdown}

class AppInfoModel {
  final String appId;
  final String appName;
  final AppType appType;
  final IconData iconPath;
  final Widget appWidget;
  final Size size;

  AppInfoModel({
    @required this.appId,
    @required this.appName,
    @required this.appType,
    @required this.iconPath,
    @required this.appWidget,
    this.size
  });
}