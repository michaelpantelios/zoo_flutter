import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class SexListItem {
  String sexName;
  int data;

  SexListItem({this.sexName = "", this.data = -1});
}

class SearchQuick extends StatefulWidget{
  SearchQuick({Key key, this.myWidth});

  final double myWidth;

  static List<SexListItem> sexListItems = [
    new SexListItem(sexName: "user_sex_none", data: -1),
    new SexListItem(sexName: "user_sex_male", data: 0),
    new SexListItem(sexName: "user_sex_female", data: 1),
    new SexListItem(sexName: "user_sex_couple", data: 2)
  ];

  SearchQuickState createState() => SearchQuickState();
}

class SearchQuickState extends State<SearchQuick>{
  SearchQuickState();

  List<DropdownMenuItem<SexListItem>> _sexDropdownMenuItems;
  SexListItem _selectedSexListItem;

  List<DropdownMenuItem<SexListItem>> buildSexDropDownMenuItems(
      List listItems) {
    List<DropdownMenuItem<SexListItem>> items = List();
    for (SexListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(AppLocalizations.of(context).translate(listItem.sexName),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.normal)),
          value: listItem,
        ),
      );
    }
    return items;
  }

  onSexChanged(SexListItem value){
    _selectedSexListItem = value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _sexDropdownMenuItems = buildSexDropDownMenuItems(SearchQuick.sexListItems);

    return Column(
      children: [
          Container(
            width: widget.myWidth,
            color: Colors.orange[700],
            padding: EdgeInsets.all(5),
            child: Text(AppLocalizations.of(context).translate("app_search_lblQuick"),
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
          ),
          Container(
            width: widget.myWidth,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color:Colors.orange[700], width: 1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    zDropdownButton(context,
                        AppLocalizations.of(context).translate("app_search_lblSearching"),
                        100,
                        SearchQuick.sexListItems[2],
                        _sexDropdownMenuItems,
                        onSexChanged
                    )
                  ],
                )
              ],
            )
          )
      ],
    );
  }
}