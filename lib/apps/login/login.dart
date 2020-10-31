import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/login/login_zoo.dart';
import 'package:zoo_flutter/apps/login/login_facebook.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/containers/alert/alert_container.dart';

enum LoginMode { zoo, facebook }

class Login extends StatefulWidget {
  Login({Key key});

  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  LoginState();

  final GlobalKey _key = GlobalKey();
  final GlobalKey<AlertContainerState> _alertKey = new GlobalKey<AlertContainerState>();
  Size size;
  LoginMode loginMode;
  List<bool> loginModeChoice;

  onLoginSuccessful(){
    print("onLoginSuccessful");

  }

  onOpenSignup(){

  }

  onAlertEmitted(String alertText){
    print("onAlertEmitted");
    _alertKey.currentState.update(alertText, new Size(size.width, size.height), 1);
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    loginMode = LoginMode.zoo;
    loginModeChoice = [true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _key,
      children: [
        Container(
            color: Theme.of(context).canvasColor,
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(
                      AppLocalizations.of(context).translate("app_login_title"),
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.left),
                ),
                getDivider(),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(
                      AppLocalizations.of(context)
                          .translate("app_login_chose_mode"),
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.left),
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
                              borderColor: Theme.of(context).buttonColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              fillColor: Color(0x00ffffff),
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  color: loginMode == LoginMode.zoo
                                      ? Color(0xffffffff)
                                      : Theme.of(context).buttonColor,
                                  width: 120,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Icon(Icons.login,
                                              color: loginMode == LoginMode.zoo
                                                  ? Theme.of(context).buttonColor
                                                  : Color(0xffffffff),
                                              size: 20)),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate("app_login_mode_zoo"),
                                        style: TextStyle(
                                          color: loginMode == LoginMode.zoo
                                              ? Theme.of(context).buttonColor
                                              : Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  color: loginMode == LoginMode.facebook
                                      ? Color(0x00ffffff)
                                      : Theme.of(context).buttonColor,
                                  width: 120,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: FaIcon(FontAwesomeIcons.facebook, size: 20,
                                              color: loginMode == LoginMode.zoo
                                                  ? Color(0xffffffff)
                                                  : Theme.of(context).buttonColor
                                          )),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate("app_login_mode_facebook"),
                                        style: TextStyle(
                                          color: loginMode == LoginMode.facebook
                                              ? Theme.of(context).buttonColor
                                              : Colors.white,
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
                                  loginMode = index == 0
                                      ? LoginMode.zoo
                                      : LoginMode.facebook;
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
                          ? LoginZoo(onLoginSuccessful: onLoginSuccessful, emitAlert: onAlertEmitted)
                          : LoginFacebook(onLoginSuccesful: onLoginSuccessful, emitAlert: onAlertEmitted),
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
                        child: Text(
                            AppLocalizations.of(context)
                                .translate("app_login_mode_zoo_create_new_account"),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ))
              ],
            )),
        AlertContainer(key: _alertKey)
      ],
    );

  }
}
