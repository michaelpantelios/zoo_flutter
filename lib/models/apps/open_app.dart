import 'package:flutter/widgets.dart';

class OpenApp{
  OpenApp({
    @required this.appId,
    @required this.key,
    @required this.active
});

  final GlobalKey key;
  final String appId;
   bool active;
}