import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/interfaces/record_set_thumb_interface.dart';

class SearchResultData {
  final int userId;
  final String photoUrl;
  final String username;
  final String quote;
  final int sex;
  final int age;
  final String country;
  final String city;

  SearchResultData(this.userId, this.photoUrl, this.username, this.quote, this.sex, this.age, this.country, this.city);
}

class SearchResultItem extends StatefulWidget{
  SearchResultItem({Key key, this.onClickHandler}) : super(key: key);

  static double myWidth = 340;
  static double myHeight = 130;

  final Function onClickHandler;

  SearchResultItemState createState() => SearchResultItemState(key: key);
}

class SearchResultItemState extends State<SearchResultItem> implements RecordSetThumbInterface {
  SearchResultItemState({Key key});

  RenderBox renderBox;
  SearchResultData _data;
  bool mouseOver = false;

  @override
  bool isEmpty;

  getDataRow(String label, String data){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                ),
            ),
            Container(
              width: SearchResultItem.myWidth * 0.4,
              child: Text(data,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                // softWrap: false,
              )
            )
          ],
        )
    );
  }

  @override
  clear() {
    setState(() {
      isEmpty = true;
    });
  }

  @override
  update(Object data) {
    setState(() {
      isEmpty = false;
      _data = data;
      renderBox = context.findRenderObject();
      print("search item renderBox  = "+renderBox.size.width.toString() + ", "+renderBox.size.height.toString());
    });
  }

  _afterLayout(_) {
     renderBox = context.findRenderObject();

    print("search item renderBox  = "+renderBox.size.width.toString() + ", "+renderBox.size.height.toString());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    isEmpty = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MouseRegion(
      onEnter: (_) {
        setState(() {
          mouseOver = true;
        });
      },
      onExit: (_) {
        setState(() {
          mouseOver = false;
        });
      },
      child: _data == null
          ? Container()
          : isEmpty ?
      Container(
          margin: EdgeInsets.all(10),
          child:  SizedBox(width: SearchResultItem.myWidth, height: SearchResultItem.myHeight)
      )
       : GestureDetector(
        onTap: (){
          widget.onClickHandler(_data.userId);
        },
        child:  Center(
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 100,
                      // height: SearchResultItem.myHeight,
                      padding: EdgeInsets.all(5),
                      child: (_data.photoUrl == "" || _data.photoUrl == null)
                          ? FaIcon(
                          _data.sex == 4
                              ? FontAwesomeIcons.userFriends
                              : Icons.face,
                          size: 100,
                          color: _data.sex == 1
                              ? Colors.blue
                              : _data.sex == 2
                              ? Colors.pink
                              : Colors.green)
                          : Image.network(_data.photoUrl,
                          fit: BoxFit.fitHeight)),
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      height: SearchResultItem.myHeight,
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.orange[700], width: 1)),
                      ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(_data.username, style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              ))
                          ),
                          getDataRow(AppLocalizations.of(context).translate("userInfo_quote"), _data.quote),
                          getDataRow(AppLocalizations.of(context).translate("userInfo_age"), _data.age.toString()),
                          getDataRow(AppLocalizations.of(context).translate("userInfo_sex"),
                              AppLocalizations.of(context).translate(
                                  _data.sex == 1 ? "user_sex_male"
                                      : _data.sex == 2 ? "user_sex_female"
                                      : _data.sex == 4 ? "user_sex_couple"
                                      : "user_sex_none")),
                          getDataRow(AppLocalizations.of(context).translate("userInfo_city"), _data.city),
                          getDataRow(AppLocalizations.of(context).translate("userInfo_country"), _data.country
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
          )
      )
    );
  }

}
