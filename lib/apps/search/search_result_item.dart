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

  static double myWidth = 340;
  static double myHeight = 130;

  final Function onClickHandler;

  SearchResultItemState createState() => SearchResultItemState();
}

class SearchResultItemState extends State<SearchResultItem>{
  SearchResultItemState();

  RenderBox renderBox;
  bool mouseOver = false;

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
  void initState() {
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
      child: GestureDetector(
        onTap: (){
          widget.onClickHandler(widget.data.userId);
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
                      child: (widget.data.mainPhoto == null)
                          ? FaIcon(
                          widget.data.me["sex"] == 4
                              ? FontAwesomeIcons.userFriends
                              : Icons.face,
                          size: 100,
                          color: widget.data.me["sex"] == 1
                              ? Colors.blue
                              : widget.data.me["sex"] == 2
                              ? Colors.pink
                              : Colors.green)
                          : Image.network(Utils.instance.getUserPhotoUrl(photoId: widget.data.mainPhoto["image_id"].toString()),
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
