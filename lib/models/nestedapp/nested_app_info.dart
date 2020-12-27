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
    print("clear data from nested app!");
    _data = null;
  }

  bool _flash = false;

  get flash => _flash;

  set flash(value) {
    _flash = value;
  }

  bool _active = false;

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
