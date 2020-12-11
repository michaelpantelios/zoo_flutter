import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/interfaces/record_set_thumb_interface.dart';
import 'package:zoo_flutter/models/search/search_result_record.dart';
import 'package:zoo_flutter/utils/utils.dart';

class SearchResultItem extends StatefulWidget{
  SearchResultItem({Key key, this.data, this.onClickHandler}) : super(key: key);

  final SearchResultRecord data;

  static double myWidth = 220;
  static double myHeight = 140;

  final Function onClickHandler;

  SearchResultItemState createState() => SearchResultItemState();
}

class SearchResultItemState extends State<SearchResultItem>{
  SearchResultItemState();

  RenderBox _renderBox;
  bool _mouseOver = false;
  String _zodiacString = "";

  getDataRow(String label, String data){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
            ),
             Container(
                  width: SearchResultItem.myWidth * 0.4,
                  child: Text(data,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 12
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.data.me["zodiacSign"] != null){
      _zodiacString = AppLocalizations.of(context).translate("zodiac").split(",")[widget.data.me["zodiacSign"] - 1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MouseRegion(
      onEnter: (_) {
        setState(() {
          _mouseOver = true;
        });
      },
      onExit: (_) {
        setState(() {
          _mouseOver = false;
        });
      },
      child: GestureDetector(
        onTap: (){
          widget.onClickHandler(int.parse(widget.data.userId.toString()));
        },
        child:
          // Center(
          //   child:
              Card(
              // margin: EdgeInsets.all(10),
              elevation: 3,
              child: Container(
                // height: SearchResultItem.myHeight,
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: SearchResultItem.myHeight - 10,
                      child: Center(
                          child: (widget.data.mainPhoto == null)
                              ? FaIcon(
                              widget.data.me["sex"] == 4
                                  ? FontAwesomeIcons.userFriends
                                  : Icons.face,
                              size: 60,
                              color: widget.data.me["sex"] == 1
                                  ? Colors.blue
                                  : widget.data.me["sex"] == 2
                                  ? Colors.pink
                                  : Colors.green)
                              : Image.network(Utils.instance.getUserPhotoUrl(photoId: widget.data.mainPhoto["image_id"].toString()),
                              width: 60)),
                    ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Text(widget.data.username, style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ))
                            ),
                            getDataRow(AppLocalizations.of(context).translate("userInfo_quote"), (widget.data.teaser.toString())),
                            getDataRow(AppLocalizations.of(context).translate("userInfo_age"), widget.data.me["age"].toString()),
                            getDataRow(AppLocalizations.of(context).translate("userInfo_sex"),
                                AppLocalizations.of(context).translate(
                                    widget.data.me["sex"] == 1 ? "user_sex_male"
                                        : widget.data.me["sex"] == 2 ? "user_sex_female"
                                        : widget.data.me["sex"] == 4 ? "user_sex_couple"
                                        : "user_sex_none")),
                            getDataRow(AppLocalizations.of(context).translate("userInfo_city"), widget.data.me["city"].toString()),
                            getDataRow(AppLocalizations.of(context).translate("userInfo_country"), Utils.instance.getCountriesNames(context)[int.parse(widget.data.me["country"].toString())].toString() ),
                            getDataRow(AppLocalizations.of(context).translate("app_profile_lblZodiac"), _zodiacString),
                          ],
                        )
                    )
                  ],
                )
              ),
            ),
          // )
      )
    );
  }

}
