import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_by_username.dart';
import 'package:zoo_flutter/apps/search/search_quick.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/models/search/search_result_record.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

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
  ScrollController _scrollController;
  RPC _rpc;
  List<SearchResultRecord> _searchResultRecords = new List<SearchResultRecord>();

  _onSearchByUsername(String username) async {
    print("onSearchByUsername");

    var res = await _rpc.callMethod("OldApps.Search.getUsers",  {"username": username} );

    if (res["status"] == "ok") {
      print("res ok");
      var records = res["data"]["records"];
      print("records.length = "+records.length.toString());
      setState(() {
        _searchResultRecords.clear();
        for(int i=0; i<records.length; i++){
          _searchResultRecords.add(SearchResultRecord.fromJSON(records[i]));
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
    // _scrollController.animateTo(_scrollController.offset - _pageWidth,
    //     curve: Curves.linear, duration: Duration(milliseconds: 500));
    // setState(() {
    //   _currentPageIndex--;
    // });
  }

  _onScrollRight(){
    // _btnLeftKey.currentState.isHidden = false;
    // _scrollController.animateTo(_scrollController.offset + _pageWidth,
    //     curve: Curves.linear, duration: Duration(milliseconds: 500));
    // setState(() {
    //   _currentPageIndex++;
    // });
  }


  _scrollListener() {
    // if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
    //     !_scrollController.position.outOfRange) {
    //   setState(() {
    //     _btnRightKey.currentState.isDisabled = true;
    //   });
    // }
    //
    // if (_scrollController.offset < _scrollController.position.maxScrollExtent && _scrollController.offset > _scrollController.position.minScrollExtent)
    //   setState(() {
    //     _btnRightKey.currentState.isDisabled = false;
    //     _btnLeftKey.currentState.isDisabled = false;
    //   });
    //
    // if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
    //     !_scrollController.position.outOfRange) {
    //   setState(() {
    //     _btnLeftKey.currentState.isDisabled = true;
    //   });
    // }
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

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _rpc = RPC();
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
       _searchResultRecords.length == 0 ? Container():
           Column(
             children: [
               Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text(AppLocalizations.of(context).translate("app_search_results_title"), style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))),
               Container(
                   width: windowWidth,
                   height: resultsHeight,
                   padding: EdgeInsets.all(5),
                   child: GridView.builder(
                     physics: const NeverScrollableScrollPhysics(),
                     // primary: false,
                     scrollDirection: Axis.horizontal,
                     controller: _scrollController,
                     itemCount: _searchResultRecords.length,
                     itemBuilder: (BuildContext context, int index) {
                       return new SearchResultItem(
                           data: _searchResultRecords[index],
                           onClickHandler: () {
                             PopupManager.instance.show(context: context, popup: PopupType.Profile, callbackAction: null);
                           });
                     },
                     gridDelegate:
                     SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: resultRows,
                         crossAxisSpacing: 14,
                         mainAxisSpacing: 14),
                   )
               )
             ],
           )
      ],
    ));
  }
}
