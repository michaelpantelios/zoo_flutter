import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/login/login_user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

enum LoginMode { zoo, facebook }

class FacebookLinker extends StatefulWidget {
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;
  final Size size;
  FacebookLinker({Key key, this.onClose, this.setBusy, this.size}) : super(key: key);

  FacebookLinkerState createState() => FacebookLinkerState();
}

class FacebookLinkerState extends State<FacebookLinker> {
  FacebookLinkerState();

  final GlobalKey _key = GlobalKey();
  RPC _rpc;
  String _fbUsername = "";
  TextEditingController _usernameInputController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  String _sex = "1";
  bool acceptTerms = true;

  @override
  void initState() {
    _rpc = RPC();
    super.initState();

    _getFBSignupData();
  }

  _getFBSignupData() async {
    var res = await _rpc.callMethod("Zoo.FbConnect.getSignupData");
    print(res);
    if (res["status"] != "ok") {
      // AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_login_${res["errorMsg"]}"));
    } else {
      setState(() {
        _fbUsername = res["data"]["name"];

        if (res["data"]["username"] != null) {
          _usernameInputController.text = res["data"]["username"];

          if (res["data"]["sex"] == "1") {
            _sex = "1";
          } else {
            _sex = "2";
          }
        }
      });
    }
  }

  getFieldsInputDecoration({double verticalPadding}) {
    double paddingV = verticalPadding == null ? 7 : verticalPadding;
    return InputDecoration(
      fillColor: Color(0xffffffff),
      filled: false,
      enabledBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      errorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      focusedBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      focusedErrorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: paddingV),
    );
  }

  _fbLink() async {
    print('fb link!!');

    var data = {"username": _usernameInputController.text, "sex": int.parse(_sex), "newsletter": acceptTerms ? 1 : 0, "facebook": 1, "importFbPhoto": 1};

    widget.setBusy(true);
    var signupRes = await _rpc.callMethod("Zoo.Account.create", [data]);
    widget.setBusy(false);

    if (signupRes["status"] != "ok") {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_signup_${signupRes["errorMsg"]}"),
        callbackAction: (retValue) {},
      );
      return;
    }
    widget.onClose(true);
    var loginUserInfo = LoginUserInfo(
      username: null,
      password: null,
      facebook: 1,
    );
    UserProvider.instance.login(loginUserInfo);
  }

  _onSignUp() {
    print('_onSignUp');
    widget.onClose(true);
    PopupManager.instance.show(context: context, popup: PopupType.Signup, callbackAction: (r) {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _fbUsername,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff000000)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Divider(),
          ),
          Html(
            data: Utils.instance.format(AppLocalizations.of(context).translate("fblinker_txtInfo"), ["<b>|</b>"]),
            style: {
              "html": Style(color: Colors.black, fontWeight: FontWeight.w500, fontSize: FontSize.medium),
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    AppLocalizations.of(context).translate("fblinker_lblUsername"),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff000000)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 7),
                  height: 30,
                  width: 400,
                  child: TextField(
                    focusNode: _usernameFocusNode,
                    controller: _usernameInputController,
                    decoration: getFieldsInputDecoration(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 50,
                        child: RadioListTile<String>(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(AppLocalizations.of(context).translate("fblinker_rdMale"), style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal)),
                          selected: _sex == "1",
                          value: "1",
                          groupValue: _sex,
                          onChanged: (String value) {
                            setState(() {
                              print("value = " + value);
                              _sex = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          width: 150,
                          height: 50,
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(AppLocalizations.of(context).translate("fblinker_rdFemale"), style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal)),
                            selected: _sex == "2",
                            value: "2",
                            groupValue: _sex,
                            onChanged: (String value) {
                              setState(() {
                                print("value = " + value);
                                _sex = value;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    AppLocalizations.of(context).translate("app_forum_accept_terms"),
                    style: TextStyle(color: Color(0xff000000), fontWeight: FontWeight.normal, fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                  value: acceptTerms,
                  onChanged: (newValue) {
                    setState(() {
                      acceptTerms = newValue;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 45),
                      child: GestureDetector(
                        onTap: () => _fbLink(),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 140,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Color(0xff3c8d40),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 28),
                                  child: Text(
                                    AppLocalizations.of(context).translate("app_coins_pm_btnContinue"),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset("assets/images/coins/continue_icon.png"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Divider(),
          ),
          GestureDetector(
            onTap: () => _onSignUp(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                AppLocalizations.of(context).translate("app_login_mode_zoo_create_new_account"),
                style: TextStyle(
                  color: Color(0xff64abff),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
