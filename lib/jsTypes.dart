@JS()
library js_types;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

// These are types of javascript objects sent from the server.

@JS()
@anonymous
class Message {
  external bool get bold;
  external int get colour;
  external String get fontFace;
  external int get fontSize;
  external String get from;
  external bool get italic;
  external String get msg;
}

@JS()
@anonymous
class User {
  external String get sex;
  external String get star;
  external bool get isChatMaster;
  external Photo get mainPhoto;
  external String get code;
  external bool get activated;
  external int get points;
  external String get userId;
  external String get level;
}

@JS()
@anonymous
class Photo {
  external String get id;
  external String get image_id; // ignore: non_constant_identifier_names
  external String get width;
  external String get height;
}

@JS()
@anonymous
class Notice {
  external String get notice;
  external String get username;
  external String get from;
}

// For converting a js object to a map with values of type T
//
Map<String, T> jsToMap<T>(Object jsObject) {
  return new Map.fromIterable(
    _getKeysOfObject(jsObject),
    value: (key) => getProperty(jsObject, key) as T,
  );
}

// Both of these interfaces exist to call `Object.keys` from Dart.
// But you don't use them directly. Just see `jsToMap`.
@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);
