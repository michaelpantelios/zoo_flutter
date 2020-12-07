@JS()
library zoo_lib;

import 'package:js/js.dart';

@JS('Zoo.Util.openWindow')
external void openWindow(url, options, name);
