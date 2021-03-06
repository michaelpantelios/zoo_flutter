import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/env.dart';

class RPC {
  Future<dynamic> callMethod(String method, [dynamic data, dynamic options]) async {
    String sessionKey = UserProvider.instance?.sessionKey;
    print("callMethod: $method with sessionKey: $sessionKey");
    String url = "${Env.RPC_URI}?access_token=" + (sessionKey == null ? "" : sessionKey);
    var chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var rnd = Random();
    var callId = String.fromCharCodes(Iterable.generate(12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    var body = new Map();
    body["id"] = callId;
    body["jsonrpc"] = "2.0";
    body["method"] = method;
    if (method.contains("OldApps")) {
      if (method.contains("Tv.getUserVideos"))
        body["params"] = [sessionKey, data[0], data[1], options];
      else
        body["params"] = [sessionKey, data, options];
    } else if (method.contains("Photos.View.getUserPhotos") || method.contains("Photos.Manage.getMyPhotos") || method.contains("Photos.Manage.setMain") || method.contains("Photos.Manage.deletePhotos"))
      body["params"] = [data, options];
    else
      body["params"] = data;

    // print(body);

    final http.Response response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    // print(body);
    var res = jsonDecode(response.body);
    // print('response: ${response.body}');
    var ret = new Map();
    ret["status"] = res["error"] == null ? "ok" : "error";
    ret["errorMsg"] = res["error"] == null ? null : res["error"]["message"];
    ret["data"] = res["result"];
    return ret;
  }
}
