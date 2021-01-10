import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/utils/utils.dart';

class ForumSearch extends StatefulWidget {
  ForumSearch({Key key, this.onCloseBtnHandler, this.onSearchHandler});

  final Function onCloseBtnHandler;
  final Function onSearchHandler;

  static double myWidth = 620;
  static double myHeight = 530;

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
              padding:EdgeInsets.only(top: 10, left: 30, right: 30, bottom:30),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom:5 ),
                    alignment: Alignment.centerLeft,
                    child: Text(AppLocalizations.of(context).translate("app_forum_search_btnByUsername"),
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                  ),
                  Container(
                      height: 215,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Color(0xff9598a4), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         zTextField(
                                context,
                                ForumSearch.myWidth - 10,
                                _usernameInputController,
                                _usernameFocusNode,
                                AppLocalizations.of(context).translate("app_forum_search_username")
                          ),
                          Container(
                              padding:EdgeInsets.only(top: 5),
                              child: Text(AppLocalizations.of(context).translate("app_forum_search_dates_lbl"),
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.w400), textAlign: TextAlign.left)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context).translate("app_forum_search_dates_from"),
                                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Container(
                                      width: 250,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9),
                                        boxShadow: [
                                          new BoxShadow(color:  Color(0xffC7C6C6), offset: new Offset(0.0, 0.0), blurRadius: 2, spreadRadius: 2),
                                        ],
                                      ),
                                      child: TextFormField(
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
                                          decoration: InputDecoration(border: InputBorder.none),
                                          controller: _dateFromCtl ,
                                          onTap: () async {
                                            FocusScope.of(context).requestFocus(new FocusNode());

                                            _dateFrom = await showDatePicker(
                                                context: context,
                                                initialDate:DateTime.now(),
                                                firstDate:DateTime(1900),
                                                lastDate: DateTime(2100));

                                            if (_dateFrom != null)
                                              _dateFromCtl.text = _dateFrom.day.toString() + " / " + _dateFrom.month.toString() + " / " + _dateFrom.year.toString();
                                          }
                                      )
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context).translate("app_forum_search_dates_to"),
                                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Container(
                                      width: 250,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9),
                                        boxShadow: [
                                          new BoxShadow(color:  Color(0xffC7C6C6), offset: new Offset(0.0, 0.0), blurRadius: 2, spreadRadius: 2),
                                        ],
                                      ),
                                      child: TextFormField(
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
                                          decoration: InputDecoration(border: InputBorder.none),
                                          controller: _dateToCtl ,
                                          onTap: () async {
                                            FocusScope.of(context).requestFocus(
                                                new FocusNode());

                                            _dateTo = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));

                                            if (_dateTo != null)
                                              _dateToCtl.text =
                                                  _dateTo.day.toString() +
                                                      " / " +
                                                      _dateTo.month.toString() +
                                                      " / " +
                                                      _dateTo.year.toString();
                                          }
                                      )
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ZButton(
                                minWidth: 160,
                                height: 40,
                                buttonColor: Color(0xff3c8d40),
                                clickHandler: (){ _onSearchByUsername(context); } ,
                                iconData: Icons.search,
                                iconColor: Colors.white,
                                iconSize: 30,
                                label: AppLocalizations.of(context).translate("app_forum_search"),
                                labelStyle: Theme.of(context).textTheme.button,
                                iconPosition: ZButtonIconPosition.right,
                              )
                            ],
                          )
                        ],
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(top:10, bottom:5 ),
                    alignment: Alignment.centerLeft,
                    child: Text(AppLocalizations.of(context).translate("app_forum_search_btnByKeywords"),
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                  ),
                  Container(
                      height: 145,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Color(0xff9598a4), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(5),
                              child:   zTextField(context,
                                ForumSearch.myWidth - 10,
                                _keywordsInputController,
                                _keywordsFocusNode,
                                AppLocalizations.of(context).translate("app_forum_search_keywords_label"),
                              )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ZButton(
                                minWidth: 160,
                                height: 40,
                                buttonColor: Color(0xff3c8d40),
                                clickHandler: (){ _onSearchByKeywords(context); },
                                iconData: Icons.search,
                                iconColor: Colors.white,
                                iconSize: 30,
                                label: AppLocalizations.of(context).translate("app_forum_search"),
                                labelStyle: Theme.of(context).textTheme.button,
                                iconPosition: ZButtonIconPosition.right,
                              )
                              ]
                          )
                        ],
                      )
                  )
                ],
              )
            )
          ],
        )

    );
  }


}