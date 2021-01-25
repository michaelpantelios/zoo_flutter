import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';

class SearchQuick extends StatefulWidget {
  SearchQuick({Key key, @required this.onSearch});

  final Function onSearch;

  static double myHeight = 230;
  static double myWidth = 480;

  SearchQuickState createState() => SearchQuickState();
}

class SearchQuickState extends State<SearchQuick> {
  SearchQuickState();

  bool _inited = false;

  List<DropdownMenuItem<int>> _sexDropdownMenuItems;
  int _selectedSex;

  List<DropdownMenuItem<int>> _ageDropdownMenuItems;
  int _selectedAgeFrom;
  int _selectedAgeTo;

  List<DropdownMenuItem<int>> _distanceDropdownMenuItems;
  int _selectedDistance;

  List<DropdownMenuItem<String>> _orderByDropdownMenuItems;
  String _selectedOrderBy;

  bool _withPhotos = false;
  bool _withVideos = false;

  onSearchHandler() {
    print("onSearchHandler");
    var criteria = {};
    criteria["sex"] = _selectedSex;
    criteria["ageFrom"] = _selectedAgeFrom;
    if (_selectedAgeTo != -1)
      criteria["ageTo"] = _selectedAgeTo;
    if (_selectedDistance != -1)
      criteria["distance"] = _selectedDistance;
    criteria["hasPhotos"] = _withPhotos;
    criteria["hasVideos"] = _withVideos;

    var options = {};
    options["order"] = _selectedOrderBy;

    widget.onSearch(crit: criteria, opt: options, refresh: true);

  }


  onSexChanged(int value) {
    setState(() {
      _selectedSex = value;
    });
  }

  onAgeFromChanged(int value) {
    setState(() {
      _selectedAgeFrom = value;
    });
  }

  onAgeToChanged(int value) {
    setState(() {
      _selectedAgeTo = value;
    });
  }

  onDistanceChanged(int value) {
    setState(() {
      _selectedDistance = value;
    });
  }

  onOrderByChanged(String value) {
    setState(() {
      _selectedOrderBy = value;
    });
  }

  @override
  void initState() {
    _sexDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _ageDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _distanceDropdownMenuItems = new List<DropdownMenuItem<int>>();
    _orderByDropdownMenuItems = new List<DropdownMenuItem<String>>();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_inited) {
      DataMocker.getSexes(context).forEach((key, val) =>
          // print(key+" :  "+value.toString())
          _sexDropdownMenuItems.add(
            DropdownMenuItem(
              child: Text(key, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal)),
              value: val,
            ),
          ));

      _selectedSex = _sexDropdownMenuItems[2].value;

      DataMocker.getAges(context).forEach((key, val) => _ageDropdownMenuItems.add(DropdownMenuItem(child: Text(key.toString(), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal)), value: val)));
      _selectedAgeFrom = _ageDropdownMenuItems[1].value;
      _selectedAgeTo = _ageDropdownMenuItems[0].value;

      DataMocker.getDistanceFromMe(context).forEach((key, val) => _distanceDropdownMenuItems.add(DropdownMenuItem(child: Text(key, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal)), value: val)));
      _selectedDistance = _distanceDropdownMenuItems[0].value;

      DataMocker.getOrder(context).forEach((key, val) => _orderByDropdownMenuItems.add(DropdownMenuItem(child: Text(key, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal)), value: val)));
      _selectedOrderBy = _orderByDropdownMenuItems[0].value;

      _inited = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 30,
            padding: EdgeInsets.only(left: 20),
            child: Text(AppLocalizations.of(context).translate("app_search_lblQuick"),
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.w400)
            )
        ),
        Container(
            height: 200,
            width: SearchQuick.myWidth,
            padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Color(0xff9597A3), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      zDropdownButton(context, AppLocalizations.of(context).translate("app_search_lblSearching"), 200, _selectedSex, _sexDropdownMenuItems, onSexChanged),
                      Expanded(child: Container()),
                      zDropdownButton(context, AppLocalizations.of(context).translate("app_search_lblAge"), 70, _selectedAgeFrom, _ageDropdownMenuItems, onAgeFromChanged),
                      Container(
                          height: 40,
                          width: 60,
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate("app_search_lblTo"),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xff9598A4),
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            )
                            )
                      ),
                      zDropdownButton(context, "", 70, _selectedAgeTo, _ageDropdownMenuItems, onAgeToChanged),
                    ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    zDropdownButton(context, AppLocalizations.of(context).translate("app_search_lblDistance"), 200, _selectedDistance, _distanceDropdownMenuItems, onDistanceChanged),
                    zDropdownButton(context, AppLocalizations.of(context).translate("app_search_lblOrderBy"), 200, _selectedOrderBy, _orderByDropdownMenuItems, onOrderByChanged),
                 ],
                ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                       width: 130,
                       height: 40,
                       child: CheckboxListTile(
                         contentPadding: EdgeInsets.all(0),
                         onChanged: (value) {
                           setState(() {
                             _withPhotos = value;
                           });
                         },
                         value: _withPhotos,
                         selected: _withPhotos,
                         title: Text(
                           AppLocalizations.of(context).translate("app_search_chkWithPhoto"),
                           style: TextStyle(color: Color(0xff9598A4), fontSize: 14, fontWeight: FontWeight.normal),
                           textAlign: TextAlign.left,
                         ),
                         controlAffinity: ListTileControlAffinity.leading,
                       )),
                   SizedBox(width: 130),
                   // Container(
                   //     width: 130,
                   //     height: 40,
                   //     child: CheckboxListTile(
                   //       contentPadding: EdgeInsets.all(0),
                   //       onChanged: (value) {
                   //         setState(() {
                   //           _withVideos = value;
                   //         });
                   //       },
                   //       value: _withVideos,
                   //       selected: _withVideos,
                   //       title: Text(
                   //         AppLocalizations.of(context).translate("app_search_chkWithVideo"),
                   //         style: TextStyle(color: Color(0xff9598A4), fontSize: 14, fontWeight: FontWeight.normal),
                   //         textAlign: TextAlign.left,
                   //       ),
                   //       controlAffinity: ListTileControlAffinity.leading,
                   //     )
                   // ),
                   Expanded(child: Container()),
                   ZButton(
                     minWidth: 160,
                     height: 40,
                     key: GlobalKey(),
                     label: AppLocalizations.of(context).translate("app_search_btnSearch"),
                     labelStyle: Theme.of(context).textTheme.button,
                     buttonColor: Color(0xff3B8D3F),
                     clickHandler: onSearchHandler,
                     iconData: Icons.search,
                     iconSize: 35,
                     iconColor: Colors.white,
                     iconPosition: ZButtonIconPosition.right,
                   )

                 ],
               )

              ],
            )
        ),
      ],
    );
  }
}
