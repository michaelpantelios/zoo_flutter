class NestedAppInfo {
  final String id;
  final String title;
  final dynamic data;

  bool _active;

  set active(value) {
    _active = value;
  }

  get active => _active;

  NestedAppInfo({this.id, this.title, this.data});

  @override
  String toString() {
    return "id: $id, title: $title, active: $_active";
  }
}
