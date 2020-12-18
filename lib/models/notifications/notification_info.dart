import 'package:zoo_flutter/providers/app_provider.dart';

class NotificationInfo {
  int _id;

  final AppType type;
  final String title;
  final String body;

  set id(value) {
    this._id = value;
  }

  get id => this._id;

  NotificationInfo(this.type, this.title, this.body);

  @override
  String toString() {
    return "id: $_id, type: $type, title: $title, body: $body";
  }
}
