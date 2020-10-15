import 'package:flutter/material.dart';

class AppButtonInfo {
  final String appId;
  final String appName;
  final IconData iconPath;
  final int order;

  AppButtonInfo({
    @required this.appId,
    @required this.appName,
    @required this.iconPath,
    @required this.order
  });

}