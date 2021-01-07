import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/interfaces/record_set_thumb_interface.dart';
import 'package:zoo_flutter/models/search/search_result_record.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

class SearchResultItem extends StatefulWidget{
  SearchResultItem({Key key}) : super(key: key);

  static double myWidth = 225;
  static double myHeight = 110;

  SearchResultItemState createState() => SearchResultItemState(key : key);
}

class SearchResultItemState extends State<SearchResultItem>{
  SearchResultItemState({Key key});

  String _zodiacString = "";
  SearchResultRecord _data;

  String _username = "";
  dynamic _userId;
  dynamic _online = 0;
  dynamic _mainPhoto;
  dynamic _sex = 1;
  dynamic _age = 0;
  dynamic _country = 0;
  dynamic _city = "";
  dynamic _zodiacSign = 0;
  String _teaser = "";

  _openProfile(BuildContext context, int userId){
    print("_openProfile " + userId.toString());
    if (!UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            if (res) {
              print("ok");
              _doOpenProfile(context, userId);
            }
          });
      return;
    }
    _doOpenProfile(context, userId);
  }

  _doOpenProfile(BuildContext context, int userId){
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId,  callbackAction: (retValue) {});
  }

  update(SearchResultRecord data){
    setState(() {
      _userId = data.userId;
      _username = data.username;
      _online = data.online;
      _mainPhoto = data.mainPhoto;
      _sex = data.me["sex"];
      _age = data.me["age"];
      _country = data.me["country"];
      _city = data.me["city"];
      _zodiacSign = data.me["zodiacSign"];
      _teaser = data.teaser == null ? "--" : data.teaser;

      if (_zodiacSign != null){
        _zodiacString = AppLocalizations.of(context).translate("zodiac").split(",")[_zodiacSign - 1];
      }
    });
  }

  clear(){
    setState(() {
      _userId = null;
    });
  }

  getDataRow(String label, String data){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
            ),
            data == null ? Container() : Container(
                  width: SearchResultItem.myWidth * 0.4,
                  child: Text(data,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 11
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
  void initState() {
    super.initState();
    // print("I am search item with data:");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return
       _userId == null ? SizedBox(width: SearchResultItem.myWidth, height: SearchResultItem.myHeight) :
      GestureDetector(
            onTap: (){
              if (_userId != null)
                _openProfile(context,_userId);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                  margin: EdgeInsets.all(5),
                  width: SearchResultItem.myWidth,
                  height: SearchResultItem.myHeight,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      new BoxShadow(color: Color(0x33000000), offset: new Offset(0.0, 0.0), blurRadius: 2, spreadRadius: 2),
                    ],
                  ),
                  child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                          child: _mainPhoto != null ?
                            Image.network(Utils.instance.getUserPhotoUrl(photoId: _mainPhoto["image_id"].toString()),
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover)
                           : Image.asset( _sex == 1 ?  "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png",
                            height: 70,
                            width: 70,
                          fit: BoxFit.cover),
                          ),
                          // Expanded(
                          //     child:
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: Text(_username, style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                          ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1
                                          )
                                      ),
                                      getDataRow(AppLocalizations.of(context).translate("userInfo_quote"), (_teaser.toString())),
                                      getDataRow(AppLocalizations.of(context).translate("userInfo_age"), _age.toString()),
                                      getDataRow(AppLocalizations.of(context).translate("userInfo_sex"),
                                          AppLocalizations.of(context).translate(
                                              _sex == 1 ? "user_sex_male"
                                                  : _sex == 2 ? "user_sex_female"
                                                  : _sex == 4 ? "user_sex_couple"
                                                  : "user_sex_none")),
                                      getDataRow(AppLocalizations.of(context).translate("userInfo_city"), _city!=null ? _city.toString() : ""),
                                      getDataRow(AppLocalizations.of(context).translate("userInfo_country"), _country != null ? Utils.instance.getCountriesNames(context)[int.parse(_country.toString())].toString() : "" ),
                                      getDataRow(AppLocalizations.of(context).translate("app_profile_lblZodiac"), _zodiacString),
                                    ],
                                  )
                              )
                          // )
                        ],
                      )

              )
            )

          )
      ;
  }

}
