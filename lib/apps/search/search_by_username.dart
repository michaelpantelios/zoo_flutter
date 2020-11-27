import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class SearchByUsername extends StatefulWidget {
  SearchByUsername({Key key});

  SearchByUsernameState createState() => SearchByUsernameState();
}

class SearchByUsernameState extends State<SearchByUsername> {
  SearchByUsernameState();

  TextEditingController _usernameController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  GlobalKey<ZButtonState> searchBtnKey = new GlobalKey<ZButtonState>();

  onSearchHandler() {
    print("Search for usernames like: " + _usernameController.text);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
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
                  child: Text(
                      AppLocalizations.of(context)
                          .translate("app_search_lblUsername"),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))),
            )
          ],
        ),
        Container(
            // width: widget.myWidth,
            padding: EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 5),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color: Colors.orange[700], width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate("app_search_lblUsernameInfo"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      zTextField(
                          context,
                          300,
                          _usernameController,
                          _usernameFocusNode,
                          AppLocalizations.of(context)
                              .translate("app_search_lblUsernameLabel"))
                    ]),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        width: 120,
                        child: ZButton(
                            key: searchBtnKey,
                            label: AppLocalizations.of(context)
                                .translate("app_search_btnSearch"),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                            buttonColor: Colors.white,
                            clickHandler: onSearchHandler))
                  ],
                )
              ],
            ))
      ],
    );
  }
}
