import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/models/signup/signup_user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';

class Signup extends StatefulWidget {
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;
  Signup({Key key, this.onClose, this.setBusy});

  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  SignupState();

  final GlobalKey _key = GlobalKey();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();
  TextEditingController _poBoxController = TextEditingController();
  FocusNode _poBoxFocusNode = FocusNode();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _passwordAgainFocusNode = FocusNode();
  int _selectedSexListItem;
  int _selectedCountryListItem;
  int _selectedBirthday;
  int _selectedMonth;
  int _selectedYear;
  bool acceptTerms = false;
  bool _newsletterSignup = true;
  RPC _rpc;
  bool _inited = false;
  List<DropdownMenuItem<int>> _sexChoices;
  List<DropdownMenuItem<int>> _countriesChoices;
  List<DropdownMenuItem<int>> _yearsChoices;
  List<DropdownMenuItem<int>> _monthsChoices;
  List<DropdownMenuItem<int>> _daysChoices;

  onSignup() async {
    print("signup!");
    var res = await _rpc.callMethod('Zoo.Account.checkUsername', [_usernameController.text]);
    print(res);
    var status = res["status"];
    if (status == "ok") {
      if (res["data"] == 1) {
        print("the user exists!");
        AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: AppLocalizations.of(context).translate("app_signup_exists"),
          dialogButtonChoice: AlertChoices.OK,
        );
      } else {
        print("username is ok to submit");
        if ((_passwordController.text != _passwordAgainController.text) && _passwordController.text != "") {
          AlertManager.instance.showSimpleAlert(
            context: context,
            bodyText: AppLocalizations.of(context).translate("passwordsDoNotMatch"),
            dialogButtonChoice: AlertChoices.OK,
          );
        } else if (!acceptTerms) {
          AlertManager.instance.showSimpleAlert(
            context: context,
            bodyText: AppLocalizations.of(context).translate("agreeToTerms"),
            dialogButtonChoice: AlertChoices.OK,
          );
        } else
          await _callServiceAccount();
      }
    } else {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate(res["errorMsg"]),
        dialogButtonChoice: AlertChoices.OK,
      );
    }
  }

  _callServiceAccount() async {
    var userInfo = SignUpUserInfo(
      username: _usernameController.text,
      password: _passwordController.text,
      email: _emailController.text,
      country: _selectedCountryListItem,
      zip: _poBoxController.text,
      city: _poBoxController.text,
      birthday: _formatBDay(),
      sex: _selectedSexListItem,
      newsletter: _newsletterSignup ? 1 : 0,
    );
    widget.setBusy(true);
    var signupRes = await _rpc.callMethod('Zoo.Account.create', [userInfo.toJson()]);
    widget.setBusy(false);
    print(signupRes);
    if (signupRes["status"] == "ok") {
      await AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_signup_success"),
        dialogButtonChoice: AlertChoices.OK,
      );
      widget.onClose(null);
    } else {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_signup_${signupRes["errorMsg"]}"),
        dialogButtonChoice: AlertChoices.OK,
      );
    }
  }

  _formatBDay() {
    return _selectedYear.toString() + "/" + (_selectedMonth < 10 ? "0" + _selectedMonth.toString() : _selectedMonth.toString()) + "/" + (_selectedBirthday < 10 ? "0$_selectedBirthday" : _selectedBirthday.toString());
  }

  @override
  void initState() {
    _rpc = RPC();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_inited) {
      _sexChoices = [];
      var sexItems = DataMocker.getSexes(context);
      sexItems.forEach((key, value) {
        _sexChoices.add(
          DropdownMenuItem(
            child: Text(
              key,
              style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
            ),
            value: value,
          ),
        );
      });
      _selectedSexListItem = DataMocker.getSexes(context).entries.where((element) => element.value == -1).first.value;

      _countriesChoices = [];
      var countries = DataMocker.getCountries(context);
      countries.forEach((key, value) {
        _countriesChoices.add(
          DropdownMenuItem(
            child: Text(key, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
            value: value,
          ),
        );
      });
      _selectedCountryListItem = _countriesChoices.where((element) => element.value == -1).first.value;

      _daysChoices = [];
      var days = DataMocker.getDays(context);
      days.forEach((key, value) {
        _daysChoices.add(
          DropdownMenuItem(
            child: Text(key, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
            value: value,
          ),
        );
      });
      _selectedBirthday = _daysChoices.where((element) => element.value == -1).first.value;

      _monthsChoices = [];
      var months = DataMocker.getMonths(context);
      months.forEach((key, value) {
        _monthsChoices.add(
          DropdownMenuItem(
            child: Text(key, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
            value: value,
          ),
        );
      });
      _selectedMonth = _monthsChoices.where((element) => element.value == -1).first.value;

      _yearsChoices = [];
      var years = DataMocker.getYears(context);
      years.forEach((key, value) {
        _yearsChoices.add(
          DropdownMenuItem(
            child: Text(key, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
            value: value,
          ),
        );
      });
      _selectedYear = _yearsChoices.where((element) => element.value == -1).first.value;

      _inited = true;
    }
    super.didChangeDependencies();
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          key: _key,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  AppLocalizations.of(context).translate("app_signup_lbltitle"),
                  style: TextStyle(
                    color: Color(0xff393e54),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
                  height: 30,
                  width: 270,
                  child: TextFormField(
                    controller: _usernameController,
                    focusNode: _usernameFocusNode,
                    decoration: getFieldsInputDecoration(),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context).translate("app_signup_lblEmail"),
                          style: TextStyle(
                            color: Color(0xff9598a4),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 360,
                        child: TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration: getFieldsInputDecoration(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            AppLocalizations.of(context).translate("app_signup_lblPostalCode"),
                            style: TextStyle(
                              color: Color(0xff9598a4),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          height: 30,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          // margin: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            controller: _poBoxController,
                            focusNode: _poBoxFocusNode,
                            decoration: getFieldsInputDecoration(),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     print("help ");
                        //   },
                        //   child: Text(
                        //     AppLocalizations.of(context).translate("app_signup_txtHelp"),
                        //     style: TextStyle(color: Colors.blue, fontSize: 10),
                        //     textAlign: TextAlign.right,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      AppLocalizations.of(context).translate("app_signup_lblPassword"),
                      style: TextStyle(
                        color: Color(0xff9598a4),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 270,
                    child: TextFormField(
                      obscureText: true,
                      obscuringCharacter: "*",
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      decoration: getFieldsInputDecoration(verticalPadding: 20),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      AppLocalizations.of(context).translate("app_signup_lblPassword2"),
                      style: TextStyle(
                        color: Color(0xff9598a4),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 270,
                    child: TextFormField(
                      obscureText: true,
                      obscuringCharacter: "*",
                      controller: _passwordAgainController,
                      focusNode: _passwordAgainFocusNode,
                      decoration: getFieldsInputDecoration(verticalPadding: 20),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context).translate("app_signup_lblSex"),
                          style: TextStyle(
                            color: Color(0xff9598a4),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      zDropdownButton(
                        context,
                        "",
                        260,
                        _selectedSexListItem,
                        _sexChoices,
                        (value) {
                          setState(() {
                            _selectedSexListItem = value;
                          });
                        },
                        blurRadius: 1,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context).translate("app_signup_lblCountry"),
                          style: TextStyle(
                            color: Color(0xff9598a4),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      zDropdownButton(
                        context,
                        "",
                        260,
                        _selectedCountryListItem,
                        _countriesChoices,
                        (value) {
                          setState(() {
                            _selectedCountryListItem = value;
                          });
                        },
                        blurRadius: 1,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context).translate("app_signup_lblBirthday"),
                          style: TextStyle(
                            color: Color(0xff9598a4),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      zDropdownButton(
                        context,
                        "",
                        120,
                        _selectedBirthday,
                        _daysChoices,
                        (value) {
                          setState(() {
                            _selectedBirthday = value;
                          });
                        },
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 19),
                    child: zDropdownButton(
                      context,
                      "",
                      220,
                      _selectedMonth,
                      _monthsChoices,
                      (value) {
                        setState(() {
                          _selectedMonth = value;
                        });
                      },
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 19),
                    child: zDropdownButton(
                      context,
                      "",
                      120,
                      _selectedYear,
                      _yearsChoices,
                      (value) {
                        setState(() {
                          _selectedYear = value;
                        });
                      },
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  AppLocalizations.of(context).translate("app_signup_chkTerms"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
                value: acceptTerms,
                onChanged: (newValue) {
                  setState(() {
                    acceptTerms = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  AppLocalizations.of(context).translate("app_signup_chkNewsletter"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
                value: _newsletterSignup,
                onChanged: (newValue) {
                  setState(() {
                    _newsletterSignup = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 50),
              child: GestureDetector(
                onTap: () {
                  print("navigate to url");
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    AppLocalizations.of(context).translate("show_privacy_policy"),
                    style: TextStyle(
                      color: Color(0xff64abff),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35, right: 30),
              child: Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: onSignup,
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
                            AppLocalizations.of(context).translate("app_signup_btnSignUp"),
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
            ),
          ],
        ),
      ),
    );
  }
}
