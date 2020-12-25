import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({this.onCloseHandler, this.onEditCompleteHandler});

  final Function onEditCompleteHandler;
  final Function onCloseHandler;

  static double myWidth = 400;
  static double myHeight = 400;

  ProfileEditState createState() => ProfileEditState();
}

class ProfileEditState extends State<ProfileEdit> {
  ProfileEditState();

  int _selectedSexListItem;
  List<DropdownMenuItem<int>> _sexChoices;
  int _selectedCountryListItem;
  List<DropdownMenuItem<int>> _countriesChoices;
  int _selectedBirthday;
  int _selectedMonth;
  int _selectedYear;
  List<DropdownMenuItem<int>> _yearsChoices;
  List<DropdownMenuItem<int>> _monthsChoices;
  List<DropdownMenuItem<int>> _daysChoices;
  TextEditingController _poBoxTextCtrl;
  String _poBox;

  ProfileInfo _info;

  _onOKHandler(){
    var data = {};
    widget.onEditCompleteHandler(data);
  }

  _onCancelHandler(){
    widget.onCloseHandler();
  }

  update(ProfileInfo info){
    setState(() {
      _info = info;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sexChoices = [];
    var sexItems = DataMocker.getSexes(context);
    sexItems.forEach((key, value) {
      _sexChoices.add(
        DropdownMenuItem(
          child: Text(
            key,
            style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
          value: value,
        ),
      );
    });
    _selectedSexListItem = DataMocker.getSexes(context)
        .entries
        .where((element) => element.value == _info.user.sex)
        .first
        .value;

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
    if (_info.country != null)
      _selectedCountryListItem = _countriesChoices
          .where((element) => element.value == _info.country)
          .first
          .value;
    else
      _selectedCountryListItem = _countriesChoices.first.value;

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


    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _info == null ? Container() :
      Container(
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PopupContainerBar(
                title: "app_name_profileEdit",
                iconData: Icons.edit,
                onClose: _onCancelHandler),
            Padding(
              padding: EdgeInsets.all(2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(
                    AppLocalizations.of(context)
                        .translate("app_profile_edit_lblSex"),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                Container(
                    width: 130,
                    height: 30,
                    child: DropdownButton(
                      value: _selectedSexListItem,
                      items: _sexChoices,
                      onChanged: (value) {
                        setState(() {
                          _selectedSexListItem = value;
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
                            initialValue:
                                _info.zip != null ? _info.zip : "",
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5.0),
                                border: OutlineInputBorder()),
                            onChanged: (value) {
                              _poBox = value;
                            }))
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
                    height: 40,
                    child: ZButton(
                      clickHandler: _onOKHandler,
                      iconData: Icons.check,
                      iconColor: Colors.green,
                      iconSize: 30,
                      label: AppLocalizations.of(context).translate("ok"),
                      labelStyle: TextStyle(color:Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                    )
                  ),
                  Container(
                      width: 100,
                      height: 40,
                      child: ZButton(
                        clickHandler: _onCancelHandler,
                        iconData: Icons.clear,
                        iconColor: Colors.red,
                        iconSize: 30,
                        label: AppLocalizations.of(context).translate("cancel"),
                        labelStyle: TextStyle(color:Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                      )
                  )
                ],
              )
            )

          ],
        ));
  }
}
