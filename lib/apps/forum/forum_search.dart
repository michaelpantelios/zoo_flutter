import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';

class ForumSearch extends StatefulWidget {
  ForumSearch({Key key, this.onCloseBtnHandler, this.onSearchHandler});

  final Function onCloseBtnHandler;
  final Function onSearchHandler;

  static double myWidth = 400;
  static double myHeight = 420;

  ForumSearchState createState() => ForumSearchState();
}

class ForumSearchState extends State<ForumSearch>{
  ForumSearchState();

  TextEditingController _usernameInputController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  TextEditingController _dateFromCtl = TextEditingController();
  TextEditingController _dateToCtl = TextEditingController();
  DateTime _dateFrom;
  DateTime _dateTo;
  TextEditingController _keywordsInputController = TextEditingController();
  FocusNode _keywordsFocusNode = FocusNode();

  _onSearchByUsername(BuildContext context){
    if (_usernameInputController.text.length == 0) {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_forum_noUsername"));
      return;
    }

    var criteria = {"username" : _usernameInputController.text};
    if (_dateFromCtl.text.length > 0)
      criteria["dateFrom"] = _dateFrom.year.toString() + (_dateFrom.month < 10? "0":"")+(_dateFrom.month).toString() + (_dateFrom.day < 10? "0":"")+ _dateFrom.day.toString();
    if (_dateToCtl.text.length > 0)
      criteria["dateTo"] = _dateTo.year.toString() + (_dateTo.month < 10? "0":"")+(_dateTo.month).toString() + (_dateTo.day < 10? "0":"")+ _dateTo.day.toString();

    widget.onSearchHandler(criteria);
  }

  _onSearchByKeywords(BuildContext context){
    if (_keywordsInputController.text.length < 3){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_forum_searchToShort"));
      return;
    }

    var criteria = {"keywords" : _keywordsInputController.text};

    widget.onSearchHandler(criteria);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ForumSearch.myWidth,
      height: ForumSearch.myHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.white,
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
            PopupContainerBar(title:  "app_forum_search", iconData: Icons.search, onClose: widget.onCloseBtnHandler),
            Container(
              height: ForumSearch.myHeight - 60,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding:EdgeInsets.all(10),
                    child: zTextField(
                        context,
                        ForumSearch.myWidth - 10,
                        _usernameInputController,
                        _usernameFocusNode,
                        AppLocalizations.of(context).translate("app_forum_search_username")
                    ),
                  ),
                  Container(
                      padding:EdgeInsets.all(10),
                      child: Text(AppLocalizations.of(context).translate("app_forum_search_dates_lbl"),
                          style: TextStyle(color:Colors.black, fontSize: 12))
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(AppLocalizations.of(context).translate("app_forum_search_dates_from"),
                              style: TextStyle(color: Colors.black, fontSize: 12)),
                          Container(
                              width: ForumSearch.myWidth * 0.5,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  )),
                              child: TextFormField(
                                  controller: _dateFromCtl ,
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(new FocusNode());

                                    _dateFrom = await showDatePicker(
                                        context: context,
                                        initialDate:DateTime.now(),
                                        firstDate:DateTime(1900),
                                        lastDate: DateTime(2100));

                                    if (_dateFrom != null)
                                      _dateFromCtl.text = _dateFrom.toString();}
                              )
                          ),
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  )),
                              child: ZButton(
                                clickHandler: (){ _dateFromCtl.text = ""; },
                                iconData: Icons.clear,
                                iconSize: 20,
                                iconColor: Colors.red,
                              )
                          )
                        ],
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(AppLocalizations.of(context).translate("app_forum_search_dates_to"),
                              style: TextStyle(color: Colors.black, fontSize: 12)),
                          Container(
                              width: ForumSearch.myWidth * 0.5,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  )),
                              child: TextFormField(
                                  controller: _dateToCtl ,
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(new FocusNode());

                                    _dateTo = await showDatePicker(
                                        context: context,
                                        initialDate:DateTime.now(),
                                        firstDate:DateTime(1900),
                                        lastDate: DateTime(2100));

                                    if (_dateTo != null)
                                      _dateToCtl.text = _dateTo.toIso8601String();}
                              )
                          ),
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  )),
                              child: ZButton(
                                clickHandler: (){ _dateToCtl.text = ""; },
                                iconData: Icons.clear,
                                iconSize: 20,
                                iconColor: Colors.red,
                              )
                          )
                        ],
                      )
                  ),
                  Container(
                      width: ForumSearch.myWidth * 0.75,
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: ZButton(
                        clickHandler: (){ _onSearchByUsername(context); } ,
                        iconData: Icons.search,
                        iconColor: Colors.blue,
                        iconSize: 20,
                        label: AppLocalizations.of(context).translate("app_forum_search_btnByUsername"),
                        labelStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(top:10, right: 5, left: 5, bottom: 10),
                      child: Divider(height: 1, thickness: 1, color: Colors.grey[600])
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child:   zTextField(context,
                        ForumSearch.myWidth - 10,
                        _keywordsInputController,
                        _keywordsFocusNode,
                        AppLocalizations.of(context).translate("app_forum_search_keywords_label"),
                      )
                  ),
                  Container(
                      width: ForumSearch.myWidth * 0.85,
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: ZButton(
                        clickHandler: (){ _onSearchByKeywords(context); },
                        iconData: Icons.search,
                        iconColor: Colors.blue,
                        iconSize: 20,
                        label: AppLocalizations.of(context).translate("app_forum_search_btnByKeywords"),
                        labelStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                      )
                  ),
                ],
              )
            )
          ],
        )

    );
  }


}