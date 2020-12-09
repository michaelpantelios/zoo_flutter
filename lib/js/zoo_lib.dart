import 'dart:js' as js;

class Zoo {
  static void FBLogin(dynamic d) {
    js.context.callMethod('fb_login', ["ho"]);
  }
}
