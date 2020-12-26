import 'package:flutter/foundation.dart';

class NestedAppInfo extends ChangeNotifier {
  final String id;
  final String title;
  List<dynamic> _data;
  addData(value) {
    if (_data == null) _data = [];
    _data.add(value);
    notifyListeners();
  }

  getData() {
    return _data;
  }

  clearData() {
    _data = null;
  }

  bool _active;

  set active(value) {
    _active = value;
  }

  get active => _active;

  NestedAppInfo({this.id, this.title});

  @override
  String toString() {
    return "id: $id, title: $title, active: $_active";
  }
}
