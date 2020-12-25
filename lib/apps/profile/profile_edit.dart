import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/utils/utils.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({Key key, this.onCloseHandler, this.onEditCompleteHandler}) : super(key: key);

  final Function onEditCompleteHandler;
  final Function onCloseHandler;

  static double myWidth = 300;
  static double myHeight = 300;

  ProfileEditState createState() => ProfileEditState(key : key);
}

class ProfileEditState extends State<ProfileEdit> {
  ProfileEditState({Key key});


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

  ProfileInfo _info;

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

    widget.onEditCompleteHandler(context, data);
  }

  _onCancelHandler(){
    widget.onCloseHandler();
  }

  update(ProfileInfo info){
    setState(() {
      _info = info;

      _currentSex = _info.user.sex;

      if (_info.country != null){
        _selectedCountryListItem = _countriesChoices
            .where((element) => element.value == _info.country)
            .first
            .value;
      }
      else
      _selectedCountryListItem = _countriesChoices.first.value;

      if ( _info.birthday != null)
        {
          print ("birthday:"+_info.birthday.toString());
          int _day = int.parse(_info.birthday.toString().split("/")[2]);
          int _month = int.parse(_info.birthday.toString().split("/")[1]);
          int _year = int.parse(_info.birthday.toString().split("/")[0]);

          _selectedBirthday = _daysChoices.where((element) => element.value == _day).first.value;
          _selectedMonth = _monthsChoices.where((element) => element.value == _month).first.value;
          _selectedYear = _yearsChoices.where((element) => element.value == _year).first.value;
        }

      _poBoxTextCtrl.text = _info.zip != null ? _info.zip : "";

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {

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

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        width: ProfileEdit.myWidth,
        height: ProfileEdit.myHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black45,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 3,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PopupContainerBar(
                title: "app_name_profileEdit",
                iconData: Icons.edit,
                onClose: _onCancelHandler),
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
                      Container(
                          width: 130,
                          height: 30,
                          child: DropdownButton(
                            value: _selectedCountryListItem,
                            items: _countriesChoices,
                            onChanged: (value) {
                              setState(() {
                                _selectedCountryListItem = value;
                              });
                            },
                          ))
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
                      Container(
                          width: 130,
                          height: 30,
                          child: TextFormField(
                            controller: _poBoxTextCtrl,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5.0),
                                border: OutlineInputBorder()
                            ),
                          )
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
              ),
              Container(
                  margin: EdgeInsets.only(top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 100,
                          height: 30,
                          child: ZButton(
                            clickHandler: _onOKHandler,
                            iconData: Icons.check,
                            iconColor: Colors.green,
                            iconSize: 20,
                            label: AppLocalizations.of(context).translate("ok"),
                            labelStyle: TextStyle(color:Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                          )
                      ),
                      Container(
                          width: 100,
                          height: 30,
                          child: ZButton(
                            clickHandler: _onCancelHandler,
                            iconData: Icons.clear,
                            iconColor: Colors.red,
                            iconSize: 20,
                            label: AppLocalizations.of(context).translate("cancel"),
                            labelStyle: TextStyle(color:Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                          )
                      )
                    ],
                  )
              )
          ],
        )
    );
  }
}
