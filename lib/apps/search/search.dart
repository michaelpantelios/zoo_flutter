import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_by_username.dart';
import 'package:zoo_flutter/apps/search/search_quick.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/apps/search/search_results.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class Search extends StatefulWidget {
  Search();

  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  SearchState();

  RenderBox renderBox;
  double windowHeight;
  double windowWidth;
  Widget results;
  int resultRows;
  int resultCols;
  final double searchAreaHeight = 200;
  double resultsHeight;
  ProfileInfo profileInfo;

  doSearch() {
    print("onSearchHandler");

    setState(() {
      List<SearchResultData> resultsData = new List<SearchResultData>();
      for (int j = 0; j < 4; j++)
        for (int i = 0; i < DataMocker.fakeProfiles.length; i++) {
          ProfileInfo profileInfo = DataMocker.fakeProfiles[i];
          resultsData.add(new SearchResultData(profileInfo.user.userId, profileInfo.user.mainPhoto, profileInfo.user.username, profileInfo.status, profileInfo.user.sex, profileInfo.age, profileInfo.country.toString(), profileInfo.city));
        }

      results = SearchResults(resData: resultsData, rows: resultRows, cols: resultCols);
    });
  }

  _afterLayout(_) {
    renderBox = context.findRenderObject();
    windowWidth = renderBox.size.width - 50;
    resultsHeight = windowHeight - searchAreaHeight - 150;
    print("resultsHeight = " + resultsHeight.toString());
    resultRows = (resultsHeight / (SearchResultItem.myHeight + 20)).floor();
    resultCols = (windowWidth / (SearchResultItem.myWidth + 20)).floor();
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
    return Container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SearchQuick(
                onSearch: doSearch,
              ),
              flex: 1,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(AppLocalizations.of(context).translate("app_search_txtOR"), style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            Flexible(
              child: SearchByUsername(
                onSearch: doSearch,
              ),
              flex: 1,
            )
          ],
        ),
        results
      ],
    ));
  }
}
