import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class LoginZoo extends StatefulWidget {
  LoginZoo({Key key, @required this.onZOOLogin});

  final Function(String username, String password, bool rememberMe) onZOOLogin;

  LoginZooState createState() => LoginZooState();
}

class LoginZooState extends State<LoginZoo> {
  LoginZooState({Key key});

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  bool rememberMe = false;

  onLogin() {
    widget.onZOOLogin(_usernameController.text, _passwordController.text, rememberMe);
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
        Text(AppLocalizations.of(context).translate("app_login_mode_zoo_username"), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.left),
        Container(
          height: 30,
          child: TextFormField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
          ),
        ),
        Container(margin: EdgeInsets.only(top: 20), child: Text(AppLocalizations.of(context).translate("app_login_mode_zoo_password"), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.left)),
        Container(
          height: 30,
          child: TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
          ),
        ),
        Container(
            height: 30,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.only(left: 5), child: Text(AppLocalizations.of(context).translate("app_login_mode_zoo_remember_me"), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.left))
              ],
            )),
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 15),
            child: RaisedButton(
                onPressed: () {
                  onLogin();
                },
                child: Text(AppLocalizations.of(context).translate("app_login_mode_zoo_btn_login"), style: Theme.of(context).textTheme.bodyText2))),
        Container(
            child: GestureDetector(
          onTap: () {
            print("you forgot");
          },
          child: Container(
            padding: EdgeInsets.all(3),
            child: Text(AppLocalizations.of(context).translate("app_login_mode_zoo_forgot_credentials"), style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ))
      ],
    );
  }
}
