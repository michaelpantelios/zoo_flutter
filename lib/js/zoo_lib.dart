@JS()
library zoo_lib;

import 'dart:async';

import 'package:js/js.dart';
import 'package:lazytime/js/aux.dart';

class Zoo {
  static Future<dynamic> fbLogin() async {
    var completer = Completer();

    _zooFBLogin(allowInterop((res) {
      completer.complete(Aux.jsToDart(res));
    }));

    return completer.future;
  }
}

@JS('Zoo.FB.login')
external dynamic _zooFBLogin(handler);