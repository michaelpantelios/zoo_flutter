import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_by_username.dart';
import 'package:zoo_flutter/apps/search/search_quick.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/models/search/search_result_record.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class Search extends StatefulWidget {
  Search();

  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  SearchState();

  double _searchFormsHeight = 250;
  RenderBox renderBox;
  double myWidth;
  RPC _rpc;
  int _servicePageIndex = 1;
  int _serviceRecsPerPageFactor = 10;

  double _resultsWidth;
  double _resultsHeight;
  int _resultRows;
  int _resultCols;
  int _itemsPerPage;

  int _totalPages = 0;
  int _currentPageIndex = 1;
  int _totalResultsNum;
  List<SearchResultRecord> _itemsFetched;

  List<List<SearchResultRecord>> _searchResultsRecordPages = new List<List<SearchResultRecord>>();

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  dynamic _searchCriteria;
  dynamic _searchOptions;


  List<Row> _rows = new List<Row>();
  List<GlobalKey<SearchResultItemState>> _itemKeysList = new List<GlobalKey<SearchResultItemState>>();

  _onSearchHandler({dynamic crit, dynamic opt, bool refresh = true}) async {
    print("_onSearchHandler");
    if (refresh){
      _servicePageIndex = 1;
      _currentPageIndex = 1;
    }

    print("----");
    print("criteria: ");
    print(crit);
    print("----");
    print("options: ");
    print(opt);
    var options = opt;
    options["recsPerPage"] = _serviceRecsPerPageFactor * _itemsPerPage;
    options["page"] = _servicePageIndex;
    options["getCount"] = refresh ? 1 : 0;

    _searchCriteria = crit;
    _searchOptions = options;

    var res = await _rpc.callMethod("OldApps.Search.getUsers",  crit, options);

    if (res["status"] == "ok") {
      print("search res ok");
      if (res["data"]["count"] != null) {
        _totalResultsNum = res["data"]["count"];
        _totalPages = (res["data"]["count"] / _itemsPerPage).ceil();
      }

      var records = res["data"]["records"];
      print("records.length = "+records.length.toString());

      if (records.length == 0)
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_search_results_noUsers"));

      if (refresh) _itemsFetched.clear();

      for (int i = 0; i<records.length; i++){
        SearchResultRecord record  = SearchResultRecord.fromJSON(records[i]);
        _itemsFetched.add(record);
      }

      if (refresh)
        _updatePageData();
      else _updatePager();

    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _updatePageData(){
    for (int i=0; i<_itemsPerPage; i++){
      int fetchedResultsIndex = ((_currentPageIndex - 1) * _itemsPerPage) + i;
      if (fetchedResultsIndex < _itemsFetched.length)
        _itemKeysList[i].currentState.update(_itemsFetched[fetchedResultsIndex]);
      else
        _itemKeysList[i].currentState.clear();
    }

    _btnLeftKey.currentState.setDisabled(_currentPageIndex > 1);

    if (_currentPageIndex == _servicePageIndex * _serviceRecsPerPageFactor &&
    _itemsFetched.length <= _currentPageIndex * _servicePageIndex * _itemsPerPage){
      print("reached Max");
      _btnRightKey.currentState.setDisabled(true);
      _servicePageIndex++;
      _onSearchHandler(crit: _searchCriteria, opt: _searchOptions, refresh : false);
    }

    _updatePager();
  }

  _updatePager(){
    setState(() {
      _btnLeftKey.currentState.setDisabled(_currentPageIndex > 1);
      _btnLeftKey.currentState.setDisabled(_currentPageIndex == 1);
      _btnRightKey.currentState.setDisabled(_currentPageIndex == _totalPages);
    });
  }

  _onScrollLeft(){
    _currentPageIndex--;
    _updatePageData();
  }

  _onScrollRight(){
    _currentPageIndex++;
    _updatePageData();
  }

  _afterLayout(_) {
    renderBox = context.findRenderObject();
    myWidth = renderBox.size.width;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _itemsFetched = [];
    _rpc = RPC();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _resultsWidth = MediaQuery.of(context).size.width - 360;
    _resultsHeight = MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - _searchFormsHeight;
    _resultRows = (_resultsHeight / SearchResultItem.myHeight).floor();
    _resultCols = (_resultsWidth / SearchResultItem.myWidth).floor();
    _itemsPerPage = _resultRows * _resultCols;
    print("_itemsPerPage = "+_itemsPerPage.toString());
    print("Search resultRows = " + _resultRows.toString());
    print("Search resultCols = " + _resultCols.toString());

    _createRows();

    super.didChangeDependencies();
  }

  _createRows(){
    _rows = new List<Row>();

    for (int i=0; i< _resultRows; i++ ){
      List<Widget> rowItems = [];
      for (int j=0; j < _resultCols; j++){
        GlobalKey<SearchResultItemState> _key = GlobalKey<SearchResultItemState>();
        _itemKeysList.add(_key);
        rowItems.add(
            SearchResultItem(
                key: _key
            )
        );
      }

      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowItems,
      );

      _rows.add(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: myWidth,
        height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
        child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SearchQuick(
                  onSearch: _onSearchHandler,
                ),
                flex: 1,
              ),
              SizedBox(width: 30),
              Flexible(
                child: SearchByUsername(
                  onSearch: _onSearchHandler,
                ),
                flex: 1,
              )
            ],
          ),
          SizedBox(height:10),
          _itemsFetched.length == 0 ? Container() :
          Container(
            padding: EdgeInsets.only(left:20, top: 5, bottom: 5),
            alignment: Alignment.centerLeft,
            color: Color(0xffF7F7F9),
            child: Text(AppLocalizations.of(context).translate("app_search_results_title"), style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))
          ),
          SizedBox(height:10),
          Container(
              width: _resultsWidth,
              height: _resultsHeight,
              child: Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _rows,
                  )
              )
          ),
          Opacity(
            opacity: _itemsFetched.length > 0 ? 1 : 0,
            child: Container(
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
            ),
          )
      ],
    ));
  }
}
