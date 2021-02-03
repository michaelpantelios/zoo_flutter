@JS()
library zoo_lib;

import 'dart:async';
import 'dart:html';

import 'package:js/js.dart';
import 'package:lazytime/js/aux.dart';

class Zoo {
  static void appLoaded() {
    _zooCanvasAppLoaded();
  }

  static Future<dynamic> fbLogin() async {
    var completer = Completer();

    _zooFBLogin(allowInterop((res) {
      completer.complete(Aux.jsToDart(res));
    }));

    return completer.future;
  }

  // convert relative URIs to absolute, respecting the <base> tag, if present
  static String _base;
  static String relativeToAbsolute(String uri) {
    if (_base == null) {
      var baseTags = document.getElementsByTagName("base");
      _base = baseTags.length > 0 ? (baseTags[0] as BaseElement).href : Uri.base.toString();
    }
    return "$_base$uri";
  }
}

@JS('Zoo.FB.login')
external dynamic _zooFBLogin(handler);

@JS('Zoo.Canvas.appLoaded')
external dynamic _zooCanvasAppLoaded();