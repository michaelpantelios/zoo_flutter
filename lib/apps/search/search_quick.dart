import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ListItem {
  String label;
  int value;

  ListItem({this.label = "", this.value = -1});
}

class SearchQuick extends StatefulWidget{
  SearchQuick({Key key});

  static List<Object> sexListItems = [
    new ListItem(label: "user_sex_none", value: -1),
    new ListItem(label: "user_sex_male", value: 1),
    new ListItem(label: "user_sex_female", value: 2),
    new ListItem(label: "user_sex_couple", value: 4)
  ];

  SearchQuickState createState() => SearchQuickState();
}

class SearchQuickState extends State<SearchQuick>{
  SearchQuickState();

  GlobalKey<ZButtonState> searchBtnKey = new GlobalKey<ZButtonState>();

  onSearchHandler(){
    print("Search");
  }

  List<DropdownMenuItem<int>> _sexDropdownMenuItems;
  int _selectedSex;

  List<DropdownMenuItem<int>> _ageDropdownMenuItems;
  int _selectedAgeFrom;
  int _selectedAgeTo;

  List<DropdownMenuItem<int>> _distanceDropdownMenuItems;
  int _selectedDistance;

  List<DropdownMenuItem<String>> _orderByDropdownMenuItems;
  int _selectedOrderBy;

  bool withPhotos = false;
  bool withVideos = false;


  onSexChanged(ListItem value){
    _selectedSex = value.value;
  }

  onAgeFromChanged(int value){
    _selectedAgeFrom = value;
  }

  onAgeToChanged(int value){
    _selectedAgeTo = value;
  }

  onDistanceChanged(int value){
    _selectedDistance = value;
  }

  onOrderByChanged(int value){
    _selectedOrderBy = value;
  }

  @override
  void initState() {
    // TODO: implement initState
    _sexDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _ageDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _distanceDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _orderByDropdownMenuItems = new List<DropdownMenuItem<String>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    DataMocker.getSexes(context).forEach((key, val) =>
      // print(key+" :  "+value.toString())
      _sexDropdownMenuItems.add(
        DropdownMenuItem(
          child: Text(key,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.normal)),
          value: val,
        ),
      )
    );

    DataMocker.getAges(context).forEach((key, val)  =>
      _ageDropdownMenuItems.add(DropdownMenuItem(
          child: Text( key.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.normal
              )),
          value: val
      )
      )
    );

    DataMocker.getDistanceFromMe(context).forEach((key, val)  =>
        _distanceDropdownMenuItems.add(DropdownMenuItem(
            child: Text( key,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                )),
            value: val
        )
        )
    );

    DataMocker.getOrder(context).forEach((key, val)  =>
        _orderByDropdownMenuItems.add(DropdownMenuItem(
            child: Text( key,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                )),
            value: val
        )
        )
    );

    return Column(
      children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  // width: widget.myWidth,
                    color: Colors.orange[700],
                    padding: EdgeInsets.all(5),
                    child: Text(AppLocalizations.of(context).translate("app_search_lblQuick"),
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
                )
              ),
            ],
          ),
          Container(
            // width: widget.myWidth,
            padding: EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 5),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color:Colors.orange[700], width: 1),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblSearching"),
                        100,
                        _sexDropdownMenuItems[2].value,
                        _sexDropdownMenuItems,
                        onSexChanged
                    ),
                    SizedBox(width: 5),
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblAge"),
                        50,
                        _ageDropdownMenuItems[1].value,
                        _ageDropdownMenuItems,
                        onAgeFromChanged
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 15, top: 10),
                      child:
                        Text(
                          AppLocalizations.of(context).translate("app_search_lblTo"),
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        )
                    ),
                    zDropdownButton(context,
                        "",
                        50,
                        _ageDropdownMenuItems[0].value,
                        _ageDropdownMenuItems,
                        onAgeToChanged
                    ),
                    SizedBox(width: 20),
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblDistance"),
                        110,
                        _distanceDropdownMenuItems[3].value,
                        _distanceDropdownMenuItems,
                        onDistanceChanged
                    ),
                    // SizedBox(width: 20),
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblOrderBy"),
                        120,
                        _orderByDropdownMenuItems[0].value,
                        _orderByDropdownMenuItems,
                        onOrderByChanged
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 110,
                      height: 40,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        onChanged: (value) {
                          setState(() {
                            withPhotos = value;
                          });
                        },
                        value: withPhotos,
                        selected: withPhotos,
                        title: Text(
                          AppLocalizations.of(context)
                              .translate("app_search_chkWithPhoto"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      )
                    ),
                    SizedBox(width: 20),
                    Container(
                        width: 110,
                        height: 40,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.all(0),
                          onChanged: (value) {
                            setState(() {
                              withVideos = value;
                            });
                          },
                          value: withVideos,
                          selected: withVideos,
                          title: Text(
                            AppLocalizations.of(context)
                                .translate("app_search_chkWithVideo"),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        )
                    )
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: 120,
                  child: ZButton(
                      key: searchBtnKey,
                      label: AppLocalizations.of(context).translate("app_search_btnSearch"),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                      buttonColor: Colors.white,
                      clickHandler: onSearchHandler
                  )
                )
              ],
            )
          )
      ],
    );
  }
}