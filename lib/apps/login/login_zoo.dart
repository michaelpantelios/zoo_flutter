import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class LoginZoo extends StatefulWidget {
  LoginZoo({Key key, @required this.onZOOLogin, @required this.onRemind, this.onSignUp});

  final Function(String username, String password, bool rememberMe) onZOOLogin;
  final Function onRemind;
  final Function onSignUp;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  AppLocalizations.of(context).translate("app_login_mode_zoo_username"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 35,
                child: TextFormField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  decoration: getFieldsInputDecoration(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context).translate("app_login_mode_zoo_password"),
                    style: TextStyle(
                      color: Color(0xff9598a4),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                height: 35,
                child: TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.left,
                  obscuringCharacter: "*",
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (s) {
                    onLogin();
                  },
                  decoration: getFieldsInputDecoration(verticalPadding: 20),
                ),
              ),
              Container(
                height: 30,
                margin: EdgeInsets.only(top: 20, bottom: 20),
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
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context).translate("app_login_mode_zoo_remember_me"),
                        style: TextStyle(
                          color: Color(0xff9598a4),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 10),
                child: GestureDetector(
                  onTap: () {
                    widget.onRemind();
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      AppLocalizations.of(context).translate("app_login_mode_zoo_forgot_credentials"),
                      style: TextStyle(
                        color: Color(0xff64abff),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    widget.onSignUp();
                  },
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
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 30),
            child: Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: onLogin,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff63ABFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate("app_login_mode_zoo_btn_login"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
