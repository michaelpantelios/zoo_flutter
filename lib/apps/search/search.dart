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
  int _serviceRecsPerPage = 100;

  RenderBox _renderBox;
  double _windowHeight;
  double _resultsWidth;
  double _resultsHeight;
  int _resultRows;
  int _resultCols;
  int _itemsPerPage;

  ScrollController _scrollController;
  int _totalPages = 0;
  int _currentPageIndex;

  List<List<SearchResultRecord>> _searchResultsRecordPages = new List<List<SearchResultRecord>>();

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  _onSearchByUsername(String username) async {
    print("onSearchByUsername");

    var res = await _rpc.callMethod("OldApps.Search.getUsers",  {"username": username},{"recsPerPage" : _serviceRecsPerPage});

    if (res["status"] == "ok") {
      print("res ok");
      var records = res["data"]["records"];
      _totalPages = (records.length / _itemsPerPage).ceil();

      print("records.length = "+records.length.toString());

      setState(() {
        _searchResultsRecordPages.clear();
        int index = -1;
        for(int i=0; i<_totalPages; i++){
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

  _onSearchQuick() async {
    print("onSearchQuick");
  }

  _onScrollLeft(){
    _scrollController.animateTo(_scrollController.offset - _resultsWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 100));
    setState(() {
      _currentPageIndex--;
    });
  }

  _onScrollRight(){
    _btnLeftKey.currentState.isHidden = false;
    _scrollController.animateTo(_scrollController.offset + _resultsWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 100));
    setState(() {
      _currentPageIndex++;
    });
  }


  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _btnRightKey.currentState.isDisabled = true;
      });
    }

    if (_scrollController.offset < _scrollController.position.maxScrollExtent && _scrollController.offset > _scrollController.position.minScrollExtent)
      setState(() {
        _btnRightKey.currentState.isDisabled = false;
        _btnLeftKey.currentState.isDisabled = false;
      });

    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _btnLeftKey.currentState.isDisabled = true;
      });
    }
  }

  _onSearchItemClick(String userId){

  }

  _afterLayout(_) {
    print("_afterLayout");
    _renderBox = context.findRenderObject();
    _resultsWidth = _renderBox.size.width - 50;
    print("windowWidth = "+_resultsWidth.toString());
    _resultsHeight = _windowHeight - 360;
    print("resultsHeight = " + _resultsHeight.toString());
    _resultRows = (_resultsHeight / SearchResultItem.myHeight).floor();
    _resultCols = (_resultsWidth / SearchResultItem.myWidth).floor();
    _itemsPerPage = _resultRows * _resultCols;
    print("Search resultRows = " + _resultRows.toString());
    print("Search resultCols = " + _resultCols.toString());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _currentPageIndex = 1;

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _rpc = RPC();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _windowHeight = MediaQuery.of(context).size.height;
    return Container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SearchQuick(
                onSearch: _onSearchQuick,
              ),
              flex: 1,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(AppLocalizations.of(context).translate("app_search_txtOR"), style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            Flexible(
              child: SearchByUsername(
                onSearch: _onSearchByUsername,
              ),
              flex: 1,
            )
          ],
        ),
       _searchResultsRecordPages.length == 0 ? Container():
           Column(
             children: [
               Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text(AppLocalizations.of(context).translate("app_search_results_title"), style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))),
               Container(
                   width: _resultsWidth,
                   height: _resultsHeight,
                   padding: EdgeInsets.all(5),
                   child: ListView.builder(
                     physics: const NeverScrollableScrollPhysics(),
                     scrollDirection: Axis.horizontal,
                     controller: _scrollController,
                     itemCount: _totalPages,
                     itemExtent: _resultsWidth,
                     cacheExtent: _resultsWidth * 2,
                     itemBuilder: (BuildContext context, int index){
                        return SearchResultsPage(
                          pageData: _searchResultsRecordPages[index],
                          rows: _resultRows,
                          cols: _resultCols,
                          myWidth: _resultsWidth,
                          onClickHandler:(int userId){
                            PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId,  callbackAction: (retValue) {});
                          },
                        );
                     }
                   )
               ),
               Container(
                 width: _resultsWidth,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     _totalPages > 1 ? ZButton(
                       key: _btnLeftKey,
                       iconData: Icons.arrow_back_ios,
                       iconColor: Colors.blue,
                       iconSize: 30,
                       clickHandler: _onScrollLeft,
                       startDisabled: true,
                     ) : Container(),
                     Container(
                       height: 30,
                       width: 120,
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
                     _totalPages > 1 ? ZButton(
                         key: _btnRightKey,
                         iconData: Icons.arrow_forward_ios,
                         iconColor: Colors.blue,
                         iconSize: 30,
                         clickHandler: _onScrollRight
                     ): Container()
                   ],
                 )
               )
             ],
           )
      ],
    ));
  }
}
