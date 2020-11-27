import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class RPC {
  String sessionKey;
  Future<dynamic> callMethod(String method, [dynamic data]) async {
    print("callMethod: ${method}");
    String url = "https://www.zoo.gr/jsonrpc/api?access_token=" + (sessionKey == null ? "" : sessionKey);
    var chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var rnd = Random();
    var callId = String.fromCharCodes(Iterable.generate(12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    var body = new Map();
    body["id"] = callId;
    body["jsonrpc"] = "2.0";
    body["method"] = method;
    body["params"] = data;
    final http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    var res = jsonDecode(response.body);
    var ret = new Map();
    ret["status"] = res["error"] == null ? "ok" : "error";
    ret["data"] = res["result"];
    return ret;
  }
}
