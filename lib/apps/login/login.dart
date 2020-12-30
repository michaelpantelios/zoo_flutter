import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/login/login_facebook.dart';
import 'package:zoo_flutter/apps/login/login_zoo.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/login/login_user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

enum LoginMode { zoo, facebook }

class Login extends StatefulWidget {
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;
  Login({this.onClose, this.setBusy}) {
    print("login constructor called");
  }

  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  LoginState();

  final GlobalKey _key = GlobalKey();
  Size size;
  LoginMode loginMode;
  List<bool> loginModeChoice;
  RPC _rpc;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    loginMode = LoginMode.zoo;
    loginModeChoice = [true, false];
    _rpc = RPC();
    print("login - initState.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _key,
      children: [
        Container(
            color: Color(0xFFffffff),
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(AppLocalizations.of(context).translate("app_login_title"), style: TextStyle(
                      fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                ),
                getDivider(),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(AppLocalizations.of(context).translate("app_login_chose_mode"), style: TextStyle(
                      fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                ),
                getDivider(),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: ToggleButtons(
                              borderColor: Color(0xff4083d5),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              fillColor: Color(0x00ffffff),
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  color: loginMode == LoginMode.zoo ? Color(0xffffffff) : Color(0xff4083d5),
                                  width: 120,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.login, color: loginMode == LoginMode.zoo ? Color(0xff4083d5) : Color(0xffffffff), size: 20)),
                                      Text(
                                        AppLocalizations.of(context).translate("app_login_mode_zoo"),
                                        style: TextStyle(
                                          color: loginMode == LoginMode.zoo ? Color(0xff4083d5) : Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  color: loginMode == LoginMode.facebook ? Color(0x00ffffff) : Color(0xff4083d5),
                                  width: 120,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsets.only(right: 5), child: FaIcon(FontAwesomeIcons.facebook, size: 20, color: loginMode == LoginMode.zoo ? Color(0xffffffff) : Color(0xff4083d5))),
                                      Text(
                                        AppLocalizations.of(context).translate("app_login_mode_facebook"),
                                        style: TextStyle(
                                          color: loginMode == LoginMode.facebook ? Color(0xff4083d5) : Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                              onPressed: (int index) {
                                print("index $index");
                                setState(() {
                                  loginMode = index == 0 ? LoginMode.zoo : LoginMode.facebook;
                                });
                              },
                              isSelected: loginModeChoice,
                            ),
                          ),
                        )
                      ],
                    )),
                Center(
                    child: Container(
                  width: 300,
                  height: 240,
                  child: loginMode == LoginMode.zoo
                      ? LoginZoo(
                          onZOOLogin: onZOOLogin,
                          onRemind: onRemind,
                        )
                      : LoginFacebook(
                          onFBLogin: onFBLogin,
                        ),
                )),
                getDivider(),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        onOpenSignup();
                      },
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: Text(AppLocalizations.of(context).translate("app_login_mode_zoo_create_new_account"), style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ))
              ],
            )),
      ],
    );
  }

  onZOOLogin(username, password, rememberMe) async {
    print("onZOOLogin: $username, $password, $rememberMe");
    if (username == "") {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_login_mode_zoo_noUsername"),
      );
    } else if (password == "") {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_login_mode_zoo_noPassword"),
      );
    } else {
      var loginUserInfo = LoginUserInfo(
        username: username,
        password: password,
        activationCode: null,
        machineCode: UserProvider.instance.getMachineCode(),
        keepLogged: rememberMe ? 1 : 0,
      );
      widget.setBusy(true);
      var loginRes = await UserProvider.instance.login(loginUserInfo);
      widget.setBusy(false);
      if (loginRes["status"] == "ok") {
        print("OK LOGIN!!!");
        widget.onClose(true);
      } else {
        AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: AppLocalizations.of(context).translate("app_login_${loginRes["errorMsg"]}"),
        );
      }
    }
  }

  onRemind() async {
    AlertManager.instance.showPromptAlert(
        context: context,
        title: AppLocalizations.of(context).translate("app_login_mode_zoo_remind_alert"),
        callbackAction: (retValue) {
          print(retValue);
          if (retValue != AlertChoices.CANCEL) {
            if (retValue == "") {
              AlertManager.instance.showSimpleAlert(
                context: context,
                bodyText: AppLocalizations.of(context).translate("app_login_invalid_email"),
              );
            } else {
              _passRemindRPC(retValue);
            }
          }
        });
  }

  _passRemindRPC(email) async {
    Map<String, String> data = Map();
    data["email"] = email;
    var remindRes = await _rpc.callMethod('Zoo.Account.remindPassword', [data]);
    print(remindRes);
    if (remindRes["status"] == "ok") {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_settings_alertFbPassOK"),
      );
    } else {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_login_${remindRes["errorMsg"]}"),
      );
    }
  }

  onFBLogin() {
    print("fb login");
  }

  onOpenSignup() {
    PopupManager.instance.show(
      context: context,
      popup: PopupType.Signup,
      callbackAction: (retValue) {
        print(retValue);
      },
    );
  }

  getDivider() {
    return Divider(
      height: 2,
      color: Colors.grey[300],
      thickness: 2,
    );
  }

  _afterLayout(_) {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    size = renderBox.size;
  }
}
