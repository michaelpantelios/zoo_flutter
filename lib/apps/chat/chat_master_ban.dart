import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ChatMasterBan extends StatefulWidget {
  final Size size;
  final Function(bool value) setBusy;
  final String username;
  final Function(dynamic) onClose;
  ChatMasterBan({@required this.size, this.setBusy, this.username, this.onClose});

  @override
  _ChatMasterBanState createState() => _ChatMasterBanState();
}

class _ChatMasterBanState extends State<ChatMasterBan> {
  RPC _rpc;

  FocusNode _adsFocusNode = FocusNode();
  TextEditingController _adsController = TextEditingController();

  FocusNode _spamFocusNode = FocusNode();
  TextEditingController _spamController = TextEditingController();

  FocusNode _personalDataFocusNode = FocusNode();
  TextEditingController _personalDataController = TextEditingController();

  FocusNode _insultFocusNode = FocusNode();
  TextEditingController _insultController = TextEditingController();
  int _defaultTimeForAds = 180;
  int _defaultTimeForSpam = 60;
  int _defaultTimeForPersonal = 500;
  int _defaultTimeForInsult = 10000;
  @override
  void initState() {
    _rpc = RPC();

    super.initState();

    _adsController.text = _defaultTimeForAds.toString();
    _spamController.text = _defaultTimeForSpam.toString();
    _personalDataController.text = _defaultTimeForPersonal.toString();
    _insultController.text = _defaultTimeForInsult.toString();
  }

  @override
  void dispose() {
    _adsController.dispose();
    _spamController.dispose();
    _personalDataController.dispose();
    _insultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            AppLocalizations.of(context).translateWithArgs("bnCv_txtUser", [widget.username]),
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Divider(
            thickness: 2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 25,
                child: TextField(
                  focusNode: _adsFocusNode,
                  controller: _adsController,
                  decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    print("ban for ads time: ${_adsController.text}");
                    widget.onClose({"type": "ad", "time": _parseTime(_adsController.text, _defaultTimeForAds)});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("bnCv_btnAds"),
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 25,
                child: TextField(
                  focusNode: _spamFocusNode,
                  controller: _spamController,
                  decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    print("ban for spam time: ${_spamController.text}");
                    widget.onClose({"type": "spam", "time": _parseTime(_spamController.text, _defaultTimeForSpam)});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("bnCv_btnFlood"),
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 25,
                child: TextField(
                  focusNode: _personalDataFocusNode,
                  controller: _personalDataController,
                  decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    print("ban for personal time: ${_personalDataController.text}");
                    widget.onClose({"type": "personal_data", "time": _parseTime(_personalDataController.text, _defaultTimeForPersonal)});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("bnCv_btnPersonal"),
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 25,
                child: TextField(
                  focusNode: _insultFocusNode,
                  controller: _insultController,
                  decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    print("ban for insult time: ${_insultController.text}");
                    widget.onClose({"type": "insult", "time": _parseTime(_insultController.text, _defaultTimeForInsult)});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("bnCv_btnInsult"),
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            AppLocalizations.of(context).translate("bnCv_txtTimeMinutes"),
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 15),
          child: Text(
            AppLocalizations.of(context).translate("bnCv_txtTimeMax"),
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
        ),
      ],
    );
  }

  _parseTime(String time, int defaultTime) {
    var t = int.tryParse(time);
    if (t == null) return defaultTime;
    return t;
  }
}
