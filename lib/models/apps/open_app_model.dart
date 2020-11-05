import 'package:flutter/widgets.dart';

class OpenAppModel{
  OpenAppModel({
    @required this.appId,
    @required this.key,
    @required this.active
});

  final GlobalKey key;
  final String appId;
   bool active;
}