import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';

class SearchByUsername extends StatefulWidget {
  SearchByUsername({Key key, @required this.onSearch});

  final Function onSearch;

  static double myHeight = 230;
  static double myWidth = 480;

  SearchByUsernameState createState() => SearchByUsernameState();
}

class SearchByUsernameState extends State<SearchByUsername> {
  SearchByUsernameState();

  TextEditingController _usernameController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          padding: EdgeInsets.only(left: 20),
          child: Text(
              AppLocalizations.of(context).translate("app_search_lblUsername"),
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.w400)
          )
        ),
        Container(
            height: 200,
            width: SearchByUsername.myWidth,
            padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Color(0xff9597A3), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate("app_search_lblUsernameInfo"),
                  style: TextStyle(
                      fontSize: 18.0, color: Color(0xff9598A4), fontWeight: FontWeight.w300),
                  textAlign: TextAlign.left,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      zTextField(
                          context, 270,
                          _usernameController,
                          _usernameFocusNode,
                          AppLocalizations.of(context).translate("app_search_lblUsernameLabel")
                      ),
                      ZButton(
                        minWidth: 160,
                        height: 40,
                        key: GlobalKey<ZButtonState>(),
                        clickHandler: () {
                          if (_usernameController.text.length < 4){
                            AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_search_lessChars"));
                          } else
                            widget.onSearch(crit: {"username":_usernameController.text}, opt:  {}, refresh:  true);
                        },
                        label: AppLocalizations.of(context).translate("app_search_btnSearch"),
                        labelStyle: Theme.of(context).textTheme.button,
                        buttonColor: Color(0xff3B8D3F),
                        iconData: Icons.search,
                        iconSize: 35,
                        iconColor: Colors.white,
                        iconPosition: ZButtonIconPosition.right,
                    )
                    ]
                ),

              ],
            )
        )
      ],
    );
  }
}
