import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_by_username.dart';
import 'package:zoo_flutter/apps/search/search_quick.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/apps/search/search_results_page.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/models/search/search_result_record.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class Search extends StatefulWidget {
  Search();

  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  SearchState();

  RPC _rpc;
  int _servicePageIndex = 1;
  int _serviceRecsPerPageFactor = 10;

  double _resultsWidth;
  double _resultsHeight;
  int _resultRows;
  int _resultCols;
  int _itemsPerPage;

  PageController _pageController;
  int _totalPages = 0;
  int _currentPageIndex = 1;

  List<List<SearchResultRecord>> _searchResultsRecordPages = new List<List<SearchResultRecord>>();

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  dynamic _searchCriteria;
  dynamic _searchOptions;

  GlobalKey<SearchResultsPageState> _resultsPageKey;

  _onSearchHandler(dynamic crit, dynamic opt) async {
    print("_onSearch");

    _currentPageIndex = 1;

    print("onSearchQuick");
    print("----");
    print("criteria: ");
    print(crit);
    print("----");
    print("options: ");
    print(opt);
    var options = opt;
    options["recsPerPage"] = _serviceRecsPerPageFactor * _itemsPerPage;
    options["page"] = _servicePageIndex;

    _searchCriteria = crit;
    _searchOptions = options;

    var res = await _rpc.callMethod("OldApps.Search.getUsers",  crit, options);

    showResults(res);
  }

  showResults(dynamic res){
    if (res["status"] == "ok") {
      print("res ok");

      var records = res["data"]["records"];
      int _tempPages = (records.length / _itemsPerPage).ceil();

      print("records.length = "+records.length.toString());

      setState(() {
        if ( _servicePageIndex == 1) {
          _searchResultsRecordPages.clear();
          _totalPages  = _tempPages;
        } else _totalPages += _tempPages;

        int index = -1;
        for(int i=0; i<_tempPages; i++){
          List<SearchResultRecord> pageItems = new List<SearchResultRecord>();
          for(int j=0; j<_itemsPerPage; j++){
            index++;
            if (index < records.length)
              pageItems.add(SearchResultRecord.fromJSON(records[index]));
          }
          _searchResultsRecordPages.add(pageItems);
        }

      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _onScrollLeft(){

  }

  _onScrollRight(){

  }

  _scrollListener() {

  }

  @override
  void initState() {
    _resultsPageKey = new GlobalKey<SearchResultsPageState>();
    _rpc = RPC();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _resultsWidth = MediaQuery.of(context).size.width - 360;
    _resultsHeight = MediaQuery.of(context).size.height - 360;
    _resultRows = (_resultsHeight / SearchResultItem.myHeight).floor();
    _resultCols = (_resultsWidth / SearchResultItem.myWidth).floor();
    _itemsPerPage = _resultRows * _resultCols;
    _serviceRecsPerPageFactor = _itemsPerPage * 10;
    print("Search resultRows = " + _resultRows.toString());
    print("Search resultCols = " + _resultCols.toString());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SearchQuick(
                  onSearch: _onSearchHandler,
                ),
                flex: 1,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(AppLocalizations.of(context).translate("app_search_txtOR"), style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Flexible(
                child: SearchByUsername(
                  onSearch: _onSearchHandler,
                ),
                flex: 1,
              )
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text(AppLocalizations.of(context).translate("app_search_results_title"), style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))),
              Center(
                  child:
                  SearchResultsPage(
                      key: _resultsPageKey,
                      rows: _resultRows,
                      cols: _resultCols,
                      myWidth: _resultsWidth-10,
                      myHeight: _resultsHeight
                  )
              ),
          Container(
              width: _resultsWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   ZButton(
                    key: _btnLeftKey,
                    iconData: Icons.arrow_back_ios,
                    iconColor: Colors.blue,
                    iconSize: 30,
                    clickHandler: _onScrollLeft,
                    startDisabled: true,
                     label: AppLocalizations.of(context).translate("previous_page"),
                     iconPosition: ZButtonIconPosition.left,
                     hasBorder: false,
                  ),
                  Container(
                    height: 30,
                    width: 200,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                            child: Html(data: AppLocalizations.of(context).translateWithArgs(
                                "pager_label", [_currentPageIndex.toString(), _totalPages.toString()]),
                                style: {
                                  "html": Style(
                                      backgroundColor: Colors.white,
                                      color: Colors.black,
                                      textAlign: TextAlign.center),
                                }))),
                  ),
                  ZButton(
                      key: _btnRightKey,
                      iconData: Icons.arrow_forward_ios,
                      iconColor: Colors.blue,
                      iconSize: 30,
                      clickHandler: _onScrollRight,
                      startDisabled: true,
                      label: AppLocalizations.of(context).translate("next_page"),
                      iconPosition: ZButtonIconPosition.right,
                      hasBorder: false,
                  )
                ],
              )
          )
      ],
    ));
  }
}
