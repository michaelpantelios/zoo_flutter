@JS()
library lazytime;

import 'dart:convert';
import 'package:js/js.dart';

class Aux {
  static dartToJs(value) => _jsJSONParse(jsonEncode(value));
  static jsToDart(value) => jsonDecode(_jsJSONStringify(value));

  static wrapHandler(String name, Function handler) =>
    _toVariadic(allowInterop((arguments) {
      try {
        Function.apply(handler, jsToDart(arguments));
      } catch(e) {
        throw "lazytime: handler for $name failled: $e";
      }
    }));
}

@JS('JSON.parse')
external dynamic _jsJSONParse(json);

@JS('JSON.stringify')
external String _jsJSONStringify(value);

@JS('lazytime._toVariadic')
external dynamic _toVariadic(code);
