import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/apps/search/search_results.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';

class SearchByUsername extends StatefulWidget {
  SearchByUsername({Key key, @required this.onSearch});

  final Function onSearch;

  SearchByUsernameState createState() => SearchByUsernameState();
}

class SearchByUsernameState extends State<SearchByUsername> {
  SearchByUsernameState();

  TextEditingController _usernameController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  GlobalKey<ZButtonState> searchBtnKey = new GlobalKey<ZButtonState>();

  double windowHeight;
  Widget results;
  int resultRows;
  final double searchAreaHeight = 200;
  double resultsHeight;
  ProfileInfo profileInfo;

  onSearchHandler() {
    print("onSearchHandler");

    setState(() {
      List<SearchResultData> resultsData = new List<SearchResultData>();
      for (int i = 0; i < DataMocker.fakeProfiles.length; i++) {
        ProfileInfo profileInfo = DataMocker.fakeProfiles[i];
        resultsData.add(new SearchResultData(profileInfo.user.userId, profileInfo.user.mainPhoto.imageId, profileInfo.user.username, profileInfo.status, profileInfo.user.sex, profileInfo.age, profileInfo.country.toString(), profileInfo.city));
      }

      results = SearchResults(resData: resultsData, rows: resultRows);
    });
  }

  _afterLayout(_) {
    resultsHeight = windowHeight - searchAreaHeight - 150;
    print("resultsHeight = " + resultsHeight.toString());
    resultRows = (resultsHeight / (SearchResultItem.myHeight + 20)).floor();
    print("resultRows = " + resultRows.toString());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    results = Container();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;

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
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [zTextField(context, 300, _usernameController, _usernameFocusNode, AppLocalizations.of(context).translate("app_search_lblUsernameLabel"))]),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Container(width: 120, child: ZButton(key: searchBtnKey, label: AppLocalizations.of(context).translate("app_search_btnSearch"), labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12), buttonColor: Colors.white, clickHandler: widget.onSearch))],
                )
              ],
            )),
        results
      ],
    );
  }
}
