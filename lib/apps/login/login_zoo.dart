import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class LoginData {
  String username;
  String password;
  bool rememberMe;

  LoginData({this.username = "", this.password = "", this.rememberMe = false});
}

class LoginZoo extends StatefulWidget {
  LoginZoo({Key key, @required this.onLoginSuccesful, @required this.emitAlert});

  final Function onLoginSuccesful;
  final Function emitAlert;

  LoginZooState createState() => LoginZooState();
}

class LoginZooState extends State<LoginZoo> {
  LoginZooState({Key key});

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  bool rememberMe = false;
  LoginData loginData = new LoginData();

  onLogin(){
    //todo
    print("onLogin");
    if (loginData.username == "")
      widget.emitAlert(Expanded(child: Center(child:Text(
          AppLocalizations.of(context).translate("app_login_mode_zoo_noUsername"),
          style: Theme.of(context).textTheme.headline6) ))
      );
    else if (loginData.password == "")
      widget.emitAlert(Text(
          AppLocalizations.of(context).translate("app_login_mode_zoo_noPassword"),
          style: Theme.of(context).textTheme.headline6)
      );
    else
    widget.onLoginSuccesful();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      AppLocalizations.of(context)
                          .translate("app_login_mode_zoo_username"),
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.left),
                Container(
                  height: 30,
                  child: TextFormField(
                    controller: _usernameController,
                    focusNode: _usernameFocusNode,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      loginData.username = value;
                    },
                    onTap: () {
                      _usernameFocusNode.requestFocus();
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("app_login_mode_zoo_password"),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left)),
                Container(
                  height: 30,
                  child: TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      loginData.password = value;
                    },
                    onTap: () {
                      _passwordFocusNode.requestFocus();
                    },
                  ),
                ),
                Container(
                    height: 30,
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value){
                            setState(() {
                              rememberMe = value;
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            AppLocalizations.of(context).translate("app_login_mode_zoo_remember_me"),
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left
                          )
                        )

                      ],
                    )),
                Container(
                  margin:EdgeInsets.only(top:10, bottom:15),
                  child: RaisedButton(
                    onPressed: (){
                      onLogin();
                    },
                    child: Text(AppLocalizations.of(context).translate("app_login_mode_zoo_btn_login"),
                    style: Theme.of(context).textTheme.bodyText2)
                  )
                ),
                Container(
                  child:GestureDetector(
                    onTap: () {
                      print("you forgot");
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      child: Text(
                          AppLocalizations.of(context).translate(
                              "app_login_mode_zoo_forgot_credentials"),
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                )
              ],
            );
  }
}
