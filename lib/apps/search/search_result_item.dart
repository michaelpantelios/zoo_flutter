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

  final Function onClickHandler;

  SearchResultItemState createState() => SearchResultItemState(key: key);
}

class SearchResultItemState extends State<SearchResultItem> implements RecordSetThumbInterface {
  SearchResultItemState({Key key});


  SearchResultData _data;
  bool mouseOver = false;
  Size size = new Size(200, 130);

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
                )
            ),
            Text(data,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14
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
    });
  }

  @override
  void initState() {
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
          margin: EdgeInsets.all(5),
          width: size.width,
          height: size.height,
          child: Center(
              child:  SizedBox(width: size.width, height: size.height)
          )
      )
       : GestureDetector(
        onTap: (){
          widget.onClickHandler(_data.userId);
        },
        child:  Center(
            child: Card(
              margin: EdgeInsets.all(5),
              elevation: 3,
              child: Row(
                children: [
                  Container(
                      width: 100,
                      height: 130,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.orange[700], width: 1)),
                      ),
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
                  Divider(
                      height: 130,
                      thickness: 1,
                      color: Colors.grey
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
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
