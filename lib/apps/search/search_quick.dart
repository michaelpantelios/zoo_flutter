import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/apps/search/search_results.dart';
import 'package:zoo_flutter/control/user.dart';

class SearchQuick extends StatefulWidget{
  SearchQuick({Key key, @required this.onSearch});

  final Function onSearch;

  SearchQuickState createState() => SearchQuickState();
}

class SearchQuickState extends State<SearchQuick>{
  SearchQuickState();

  double windowHeight;
  Widget results;
  int resultRows;
  final double searchAreaHeight = 200;
  double resultsHeight;
  bool _inited = false;

  GlobalKey<ZButtonState> searchBtnKey = new GlobalKey<ZButtonState>();

  onSearchHandler(){
    print("onSearchHandler");

      setState(() {
        List<SearchResultData> resultsData = new List<SearchResultData>();
        for(int i=0; i< DataMocker.users.length; i++){
          UserInfoModel user = DataMocker.users[i];
          resultsData.add(new SearchResultData(
              user.userId,
              user.photoUrl,
              user.username,
              user.quote,
              user.sex,
              user.age,
              user.country,
              user.city)
          );
        }

        results = SearchResults(resData: resultsData, rows: resultRows);
      });

  }

  List<DropdownMenuItem<int>> _sexDropdownMenuItems;
  int _selectedSex;

  List<DropdownMenuItem<int>> _ageDropdownMenuItems;
  int _selectedAgeFrom;
  int _selectedAgeTo;

  List<DropdownMenuItem<int>> _distanceDropdownMenuItems;
  int _selectedDistance;

  List<DropdownMenuItem<String>> _orderByDropdownMenuItems;
  String _selectedOrderBy;

  bool withPhotos = false;
  bool withVideos = false;

  onSexChanged(int value){
    setState(() {
      _selectedSex = value;
    });
  }

  onAgeFromChanged(int value){
    setState(() {
      _selectedAgeFrom = value;
    });
  }

  onAgeToChanged(int value){
    setState(() {
      _selectedAgeTo = value;
    });
  }

  onDistanceChanged(int value){
    setState(() {
      _selectedDistance = value;
    });
  }

  onOrderByChanged(String value){
    setState(() {
      _selectedOrderBy = value;
    });
  }

  _afterLayout(_) {
    resultsHeight = windowHeight - searchAreaHeight - 150;
    print("resultsHeight = "+resultsHeight.toString());
    resultRows = (resultsHeight / (SearchResultItem.myHeight+20)).floor();
    print("resultRows = "+resultRows.toString());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    results = Container();
    _sexDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _ageDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _distanceDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _orderByDropdownMenuItems = new List<DropdownMenuItem<String>>();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_inited){
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
      _selectedSex = _sexDropdownMenuItems[2].value;

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
      _selectedAgeFrom = _ageDropdownMenuItems[1].value;
      _selectedAgeTo = _ageDropdownMenuItems[0].value;

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
      _selectedDistance = _distanceDropdownMenuItems[0].value;

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
      _selectedOrderBy = _orderByDropdownMenuItems[0].value;

      _inited = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    print("mediaquery: "+MediaQuery.of(context).size.height.toString());

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
            height: 160,
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color:Colors.orange[700], width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblSearching"),
                        100,
                        _selectedSex,
                        _sexDropdownMenuItems,
                        onSexChanged
                    ),
                    SizedBox(width: 40),
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblAge"),
                        50,
                        _selectedAgeFrom,
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
                        _selectedAgeTo,
                        _ageDropdownMenuItems,
                        onAgeToChanged
                    ),
                    SizedBox(width: 40),
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblDistance"),
                        110,
                        _selectedDistance,
                        _distanceDropdownMenuItems,
                        onDistanceChanged
                    ),
                    SizedBox(width: 40),
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblOrderBy"),
                        120,
                        _selectedOrderBy,
                        _orderByDropdownMenuItems,
                        onOrderByChanged
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                SizedBox(height: 10),
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
                      clickHandler: widget.onSearch
                  )
                )
              ],
            )
          ),
          results
      ],
    );
  }
}