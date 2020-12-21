import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';

class SearchByUsername extends StatefulWidget {
  SearchByUsername({Key key, @required this.onSearch});

  final Function onSearch;

  SearchByUsernameState createState() => SearchByUsernameState();
}

class SearchByUsernameState extends State<SearchByUsername> {
  SearchByUsernameState();

  TextEditingController _usernameController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                  // width: widget.myWidth,
                  color: Colors.orange[700],
                  padding: EdgeInsets.all(5),
                  child: Text(AppLocalizations.of(context).translate("app_search_lblUsername"), style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            )
          ],
        ),
        Container(
            height: 160,
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color: Colors.orange[700], width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate("app_search_lblUsernameInfo"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left,
                ),

                Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      zTextField(
                          context, 300,
                          _usernameController,
                          _usernameFocusNode,
                          AppLocalizations.of(context).translate("app_search_lblUsernameLabel")
                      )
                    ]
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        width: 120,
                        child: ZButton(
                            key: GlobalKey<ZButtonState>(),
                            clickHandler: () {
                              if (_usernameController.text.length < 4){
                                AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_search_lessChars"));
                              } else
                                // widget.onSearch({"username":_usernameController.text}, {});
                              widget.onSearch({"username": "mike"}, {});
                            },
                            label: AppLocalizations.of(context).translate("app_search_btnSearch"),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                            buttonColor: Colors.white
                            )
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
