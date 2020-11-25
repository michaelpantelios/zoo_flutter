import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/containers/alert/alert_container.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class SignupData {
  String username = "";
  String email = "";
  String password = "";
  int sex = -1;
  String poBox = "";

  SignupData();
}

class SexListItem {
  String sexName;
  int data;

  SexListItem({this.sexName = "", this.data = -1});
}

class CountryListItem {
  String countryName;
  int data;

  CountryListItem({this.countryName = "", this.data = -1});
}

class MonthListItem {
  String month;
  int data;

  MonthListItem({this.month = "", this.data = -1});
}

class YearListItem {
  String year;
  int data;

  YearListItem({this.year = "", this.data = -1});
}

class Signup extends StatefulWidget {
  Signup({Key key});

  static List<SexListItem> sexListItems = [new SexListItem(sexName: "user_sex_none", data: -1), new SexListItem(sexName: "user_sex_male", data: 0), new SexListItem(sexName: "user_sex_female", data: 1), new SexListItem(sexName: "user_sex_couple", data: 2)];

  static List<CountryListItem> countryListItems = [new CountryListItem(countryName: "--", data: -1), new CountryListItem(countryName: "Ελλάδα", data: 0), new CountryListItem(countryName: "Γαλλία", data: 1), new CountryListItem(countryName: "Γερμανία", data: 2), new CountryListItem(countryName: "Η.Π.Α.", data: 3)];

  static List<MonthListItem> monthListItems = [
    new MonthListItem(month: "--", data: -1),
    new MonthListItem(month: "Ιανουάριος", data: 1),
    new MonthListItem(month: "Φεβρουάριος", data: 2),
    new MonthListItem(month: "Μάρτιος", data: 3),
    new MonthListItem(month: "Απρίλιος", data: 4),
    new MonthListItem(month: "Μάιος", data: 5),
    new MonthListItem(month: "Ιούνιος", data: 6),
    new MonthListItem(month: "Ιούλιος", data: 7),
    new MonthListItem(month: "Αύγουστος", data: 8),
    new MonthListItem(month: "Σεπτέμβριος", data: 9),
    new MonthListItem(month: "Οκτώβριος", data: 10),
    new MonthListItem(month: "Νοέμβριος", data: 11),
    new MonthListItem(month: "Δεκέμβριος", data: 12),
  ];

  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  SignupState();

  final GlobalKey _key = GlobalKey();
  final GlobalKey<AlertContainerState> _alertKey = new GlobalKey<AlertContainerState>();
  Size size;
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
  SignupData signupData = new SignupData();
  List<DropdownMenuItem<SexListItem>> _sexDropdownMenuItems;
  List<DropdownMenuItem<CountryListItem>> _countryDropdownMenuItems;
  SexListItem _selectedSexListItem;
  CountryListItem _selectedCountryListItem;
  List<DropdownMenuItem<String>> _birthDayMenuItems;
  String _selectedBirthday;
  List<DropdownMenuItem<MonthListItem>> _monthDropdownMenuItems;
  MonthListItem _selectedMonth;
  List<YearListItem> _yearItems = new List<YearListItem>();
  List<DropdownMenuItem<YearListItem>> _yearDropdownMenuItems;
  YearListItem _selectedYear;
  bool acceptTerms = false;
  bool newsletterSignup = true;

  List<DropdownMenuItem<SexListItem>> buildSexDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<SexListItem>> items = List();
    for (SexListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(AppLocalizations.of(context).translate(listItem.sexName), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<CountryListItem>> buildCountryDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<CountryListItem>> items = List();
    for (CountryListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.countryName, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildBirthdayDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    items.add(DropdownMenuItem(child: Text("--", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)), value: "--"));
    for (int i = 1; i <= 31; i++) {
      items.add(DropdownMenuItem(child: Text(i.toString(), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)), value: i.toString()));
    }
    return items;
  }

  List<DropdownMenuItem<MonthListItem>> buildMonthDropDownMenuItems() {
    List<DropdownMenuItem<MonthListItem>> items = List();
    for (MonthListItem listItem in Signup.monthListItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.month, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<YearListItem>> buildYearDropDownMenuItems() {
    List<DropdownMenuItem<YearListItem>> items = List();
    for (YearListItem yearListItem in _yearItems) {
      items.add(DropdownMenuItem(
        child: Text(yearListItem.year.toString(), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
        value: yearListItem,
      ));
    }
    return items;
  }

  onSignup() {
    if (signupData.username == "") _alertKey.currentState.update(AppLocalizations.of(context).translate("app_signup_invalid_username"), new Size(size.width, size.height), new Size(size.width * 0.75, size.height * 0.4), 1);
  }

  onOkAlertHandler() {}

  _afterLayout(_) {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    size = renderBox.size;
  }

  @override
  void initState() {
    super.initState();
    _selectedSexListItem = Signup.sexListItems.where((element) => element.data == -1).first;
    _selectedCountryListItem = Signup.countryListItems.where((element) => element.data == -1).first;
    _selectedBirthday = "--";
    _selectedMonth = Signup.monthListItems.where((element) => element.data == -1).first;

    _selectedYear = new YearListItem(year: "--", data: -1);
    _yearItems.add(_selectedYear);
    int maxYear = DateTime.now().year - 18;
    int minYear = 1940;
    for (int i = minYear; i <= maxYear; i++) _yearItems.add(new YearListItem(year: i.toString(), data: -1));

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  Widget build(BuildContext context) {
    _sexDropdownMenuItems = buildSexDropDownMenuItems(Signup.sexListItems);
    _countryDropdownMenuItems = buildCountryDropDownMenuItems(Signup.countryListItems);
    _birthDayMenuItems = buildBirthdayDropDownMenuItems();
    _monthDropdownMenuItems = buildMonthDropDownMenuItems();
    _yearDropdownMenuItems = buildYearDropDownMenuItems();
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
                                onChanged: (value) {
                                  signupData.username = value;
                                  print("check username: " + value);
                                },
                                onTap: () {
                                  _usernameFocusNode.requestFocus();
                                },
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
                                onChanged: (value) {
                                  signupData.email = value;
                                },
                                onTap: () {
                                  _emailFocusNode.requestFocus();
                                },
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
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                              onChanged: (value) {
                                signupData.password = value;
                              },
                              onTap: () {
                                _passwordFocusNode.requestFocus();
                              },
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
                              controller: _passwordAgainController,
                              focusNode: _passwordAgainFocusNode,
                              decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                              onChanged: (value) {
                                //todo
                              },
                              onTap: () {
                                _passwordAgainFocusNode.requestFocus();
                              },
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
                                      value: Signup.sexListItems[0],
                                      items: _sexDropdownMenuItems,
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
                                      items: _countryDropdownMenuItems,
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
                                      onChanged: (value) {
                                        //todo
                                      },
                                      onTap: () {
                                        _poBoxFocusNode.requestFocus();
                                      },
                                    )),
                                GestureDetector(
                                    onTap: () {},
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
                              items: _birthDayMenuItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedBirthday = value;
                                });
                              },
                            ),
                            DropdownButton(
                              value: _selectedMonth,
                              items: _monthDropdownMenuItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMonth = value;
                                });
                              },
                            ),
                            DropdownButton(
                              value: _selectedYear,
                              items: _yearDropdownMenuItems,
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
                      value: newsletterSignup,
                      onChanged: (newValue) {
                        setState(() {
                          newsletterSignup = newValue;
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
                            onTap: () {},
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
                        RaisedButton(onPressed: () {}, child: Text(AppLocalizations.of(context).translate("app_signup_btnCancel"), style: Theme.of(context).textTheme.button))
                      ],
                    ))
              ],
            )),
        AlertContainer(key: _alertKey)
      ],
    );
  }
}
