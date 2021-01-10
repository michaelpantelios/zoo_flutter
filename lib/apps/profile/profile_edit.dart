import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:zoo_flutter/utils/utils.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({this.profileInfo, this.size,  this.onClose});

  final Function onClose;

  final ProfileInfo profileInfo;
  final Size size;

  ProfileEditState createState() => ProfileEditState();
}

class ProfileEditState extends State<ProfileEdit> {
  ProfileEditState();


  int _selectedCountryListItem;
  List<DropdownMenuItem<int>> _countriesChoices;
  int _selectedBirthday;
  int _selectedMonth;
  int _selectedYear;
  List<DropdownMenuItem<int>> _yearsChoices;
  List<DropdownMenuItem<int>> _monthsChoices;
  List<DropdownMenuItem<int>> _daysChoices;
  TextEditingController _poBoxTextCtrl = TextEditingController();
  dynamic _currentSex = 0;

  _onOKHandler(){

    if (_selectedCountryListItem == -1){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_profile_edit_noCountrySelected"));
      return;
    }

    if (_poBoxTextCtrl.text.length == 0){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_profile_edit_noCitySelected"));
      return;
    }

    if (_selectedBirthday == -1){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_profile_edit_noDaySelected"));
      return;
    }

    if (_selectedMonth == -1){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_profile_edit_noMonthSelected"));
      return;
    }

    if (_selectedYear == -1){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_profile_edit_noYearSelected"));
      return;
    }

    var data = {};
    // data["sex"] = _info.user.sex;
    data["country"] = _selectedCountryListItem;
    data["zip"] = _poBoxTextCtrl.text;
    data["birthday"] = _selectedYear.toString() + "/" + (_selectedMonth < 10 ? "0" + _selectedMonth.toString() : _selectedMonth.toString())  + "/" + _selectedBirthday.toString();

    widget.onClose(data);
  }

  _onCancelHandler(){
    widget.onClose();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _currentSex = widget.profileInfo.user.sex;

    _countriesChoices = [];
    var countries = DataMocker.getCountries(context);
    countries.forEach((key, value) {
      _countriesChoices.add(
        DropdownMenuItem(
          child: Text(key,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.normal)),
          value: value,
        ),
      );
    });

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

    if (widget.profileInfo.country != null){
      print("My Country is: "+widget.profileInfo.country.toString());

      _selectedCountryListItem = _countriesChoices
          .where((element) => element.value == int.parse(widget.profileInfo.country.toString()))
          .first
          .value;
    }
    else
      _selectedCountryListItem = _countriesChoices.first.value;

    if ( widget.profileInfo.birthday != null)
    {
      print ("birthday:"+widget.profileInfo.birthday.toString());
      int _day = int.parse(widget.profileInfo.birthday.toString().split("/")[2]);
      int _month = int.parse(widget.profileInfo.birthday.toString().split("/")[1]);
      int _year = int.parse(widget.profileInfo.birthday.toString().split("/")[0]);

      _selectedBirthday = _daysChoices.where((element) => element.value == _day).first.value;
      _selectedMonth = _monthsChoices.where((element) => element.value == _month).first.value;
      _selectedYear = _yearsChoices.where((element) => element.value == _year).first.value;
    }

    _poBoxTextCtrl.text = widget.profileInfo.zip != null ? widget.profileInfo.zip : "";


    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Container(
                margin: EdgeInsets.only(top:10),
                padding: EdgeInsets.all(2),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          AppLocalizations.of(context)
                              .translate("app_profile_edit_lblSex"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)
                      ),
                      Container(
                        width: 130,
                        height: 20,
                        child: Text(Utils.instance.getSexString(context, _currentSex), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ]),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          AppLocalizations.of(context)
                              .translate("app_profile_edit_lblCountry"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                      zDropdownButton(
                          context,
                          "",
                          130,
                        _selectedCountryListItem,
                        _countriesChoices,
                          (value) {
                            setState(() {
                              _selectedCountryListItem = value;
                            });
                          },
                      )
                    ]),
              ),
              Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          AppLocalizations.of(context)
                              .translate("app_profile_edit_lblZip"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                      zTextField(
                        context,
                        130,
                        _poBoxTextCtrl,
                        FocusNode(),
                        ""
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.all(2),
                child: Text(AppLocalizations.of(context).translate("app_profile_edit_lblBirthday"),
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      zDropdownButton(
                        context,
                        "",
                        50,
                        _selectedBirthday,
                        _daysChoices,
                        (value) {
                          setState(() {
                            _selectedBirthday = value;
                          });
                        },
                      ),
                      zDropdownButton(
                        context,
                        "",
                        120,
                        _selectedMonth,
                         _monthsChoices,
                          (value) {
                          setState(() {
                            _selectedMonth = value;
                          });
                        },
                      ),
                      zDropdownButton(
                        context,
                        "",
                        60,
                        _selectedYear,
                        _yearsChoices,
                        (value) {
                          setState(() {
                            _selectedYear = value;
                          });
                        },
                      )
                    ],
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     ZButton(
                      minWidth: 120,
                      height: 40,
                      buttonColor: Colors.green,
                      clickHandler: _onOKHandler,
                      iconData: Icons.check,
                      iconColor: Colors.white,
                      iconSize: 30,
                      label: AppLocalizations.of(context).translate("ok"),
                      labelStyle: Theme.of(context).textTheme.button,
                    ),
                    ZButton(
                      minWidth: 120,
                      height: 40,
                      buttonColor: Colors.red,
                      clickHandler: _onCancelHandler,
                      iconData: Icons.clear,
                      iconColor: Colors.white,
                      iconSize: 30,
                      label: AppLocalizations.of(context).translate("cancel"),
                      labelStyle:Theme.of(context).textTheme.button,
                    )
                  ],
                )
            )
          ],
        )
    );
  }
}
