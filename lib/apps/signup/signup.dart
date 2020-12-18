import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/models/signup/signup_user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _key,
      children: [
        Container(
            color: Theme.of(context).canvasColor,
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context).translate("app_login_mode_zoo_username"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
                            Container(
                              height: 30,
                              width: 270,
                              child: TextFormField(
                                controller: _usernameController,
                                focusNode: _usernameFocusNode,
                                decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context).translate("app_signup_lblEmail"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
                            Container(
                              height: 30,
                              width: 270,
                              child: TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context).translate("app_signup_lblPassword"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
                          Container(
                            height: 30,
                            width: 270,
                            child: TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5.0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context).translate("app_signup_lblPassword2"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
                          Container(
                            height: 30,
                            width: 270,
                            child: TextFormField(
                              obscureText: true,
                              controller: _passwordAgainController,
                              focusNode: _passwordAgainFocusNode,
                              decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                    width: 580,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context).translate("app_signup_lblSex"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: DropdownButton(
                                      value: _selectedSexListItem,
                                      items: _sexChoices,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSexListItem = value;
                                        });
                                      },
                                    ))
                              ],
                            )),
                        SizedBox(width: 10),
                        Container(
                            width: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context).translate("app_signup_lblCountry"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: DropdownButton(
                                      value: _selectedCountryListItem,
                                      items: _countriesChoices,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCountryListItem = value;
                                        });
                                      },
                                    ))
                              ],
                            )),
                        SizedBox(width: 10),
                        Container(
                            width: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context).translate("app_signup_lblPostalCode"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
                                Container(
                                    height: 40,
                                    padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                                    // margin: EdgeInsets.only(bottom: 5),
                                    child: TextFormField(
                                      controller: _poBoxController,
                                      focusNode: _poBoxFocusNode,
                                      decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      print("help ");
                                    },
                                    child: Text(
                                      AppLocalizations.of(context).translate("app_signup_txtHelp"),
                                      style: TextStyle(color: Colors.blue, fontSize: 10),
                                      textAlign: TextAlign.right,
                                    ))
                              ],
                            ))
                      ],
                    )),
                Container(
                    width: 580,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).translate("app_signup_lblBirthday"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownButton(
                              value: _selectedBirthday,
                              items: _daysChoices,
                              onChanged: (value) {
                                setState(() {
                                  _selectedBirthday = value;
                                });
                              },
                            ),
                            DropdownButton(
                              value: _selectedMonth,
                              items: _monthsChoices,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMonth = value;
                                });
                              },
                            ),
                            DropdownButton(
                              value: _selectedYear,
                              items: _yearsChoices,
                              onChanged: (value) {
                                setState(() {
                                  _selectedYear = value;
                                });
                              },
                            )
                          ],
                        )
                      ],
                    )),
                Container(
                    width: 580,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    child: Container(
                        child: CheckboxListTile(
                      title: Text(
                        AppLocalizations.of(context).translate("app_signup_chkTerms"),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      value: acceptTerms,
                      onChanged: (newValue) {
                        setState(() {
                          acceptTerms = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                    ))),
                Container(
                    width: 580,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    child: Container(
                        child: CheckboxListTile(
                      title: Text(
                        AppLocalizations.of(context).translate("app_signup_chkNewsletter"),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      value: _newsletterSignup,
                      onChanged: (newValue) {
                        setState(() {
                          _newsletterSignup = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                    ))),
                Container(
                    width: 580,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child: GestureDetector(
                            onTap: () {
                              print("navigate to url");
                            },
                            child: Text(
                              AppLocalizations.of(context).translate("show_privacy_policy"),
                              style: TextStyle(color: Colors.blue, fontSize: 10),
                              textAlign: TextAlign.right,
                            )))),
                Container(
                    width: 580,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                            onPressed: () {
                              onSignup();
                            },
                            child: Text(AppLocalizations.of(context).translate("app_signup_btnSignUp"), style: Theme.of(context).textTheme.button)),
                        SizedBox(width: 10),
                        RaisedButton(
                          onPressed: () {
                            print("signup just close.");
                            widget.onClose(null);
                          },
                          child: Text(
                            AppLocalizations.of(context).translate("app_signup_btnCancel"),
                            style: Theme.of(context).textTheme.button,
                          ),
                        )
                      ],
                    ))
              ],
            )),
      ],
    );
  }
}
