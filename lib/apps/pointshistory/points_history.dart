import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zoo_flutter/apps/pointshistory/points_history_item.dart';
import 'package:zoo_flutter/models/pointshistory/points_history_model.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class PointsHistory extends StatefulWidget {
  PointsHistory({this.size});
  
  final Size size;

  PointsHistoryState createState() => PointsHistoryState();
}

class PointsHistoryState extends State<PointsHistory>{
  PointsHistoryState();

  RPC _rpc;

  int _currentServicePage = 1;
  int _serviceRecsPerPageFactor = 5;

  int _rowsPerPage = 10;

  List<GlobalKey<PointsHistoryItemState>> _itemKeys = [];
  List<Widget> _items = [];
  List<PointsHistoryModel> _resultRecords = [];

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  int _totalRecsNum = 0;
  int _totalPages = 0;
  int _currentPage = 1;

  _onPreviousPage(){
    _currentPage--;
    _updatePageData();
  }

  _onNextPage(){
    _currentPage++;
    _updatePageData();
  }

  addPostFrameCallback(_){
    _getHistory();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(addPostFrameCallback);

    _rpc = RPC();

    for (int i=0; i<_rowsPerPage; i++){
     GlobalKey<PointsHistoryItemState> _key = GlobalKey<PointsHistoryItemState>();
     _items.add(PointsHistoryItem(key: _key,));
     _itemKeys.add(_key);
    }
  }

  _getHistory({bool addMore = false}) async {
    var options = {};
    options["page"] = _currentServicePage;
    options["recsPerPage"] = _rowsPerPage * _serviceRecsPerPageFactor;
    options["getCount"] = addMore == true ? 0 : 1;

    var res = await _rpc.callMethod("Points.Main.getPointsHistory", [options]);

    if(res["status"] == "ok"){
      print(res);
      if (res["data"]["count"] != null) {
        _totalRecsNum = res["data"]["count"];
        _totalPages = (res["data"]["count"] / _rowsPerPage).ceil();
      }

      var records = res["data"]["records"];

      if (!addMore) _resultRecords.clear();

      for(int i=0; i<records.length; i++){
        _resultRecords.add(PointsHistoryModel.fromJSON(records[i]));
      }

      if (!addMore)
        _updatePageData();
      else _updatePager();

    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _updatePageData(){
    for(int i=0; i<_rowsPerPage; i++){
      int fetchedDataIndex = ((_currentPage - 1) * _rowsPerPage) + i;
      if (fetchedDataIndex < _resultRecords.length)
        _itemKeys[i].currentState.update(_resultRecords[fetchedDataIndex], i);
      else _itemKeys[i].currentState.clear();
    }

    if (_currentPage == _currentServicePage * _serviceRecsPerPageFactor
        && _resultRecords.length <= _currentPage * _currentServicePage * _rowsPerPage){
      print("reached Max");
      _btnRightKey.currentState.setDisabled(true);
      _currentServicePage++;
      _getHistory(addMore: true);
    }

    _updatePager();
  }

  _updatePager(){
    setState(() {
      _btnLeftKey.currentState.setDisabled(_currentPage == 1);
      _btnRightKey.currentState.setDisabled(_currentPage == _totalPages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).translate("app_pointshistory_activity_label"),
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
          textAlign: TextAlign.left),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: widget.size.width - 40,
            height: widget.size.height - 130,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xff9598a4),
                  width: 2,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(9)
                )
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _items,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ZButton(
                          minWidth: 40,
                          height: 40,
                          key: _btnLeftKey,
                          iconData: Icons.arrow_back_ios,
                          iconColor: Colors.blue,
                          iconSize: 30,
                          clickHandler: _onPreviousPage,
                          startDisabled: true
                      ),
                      Container(
                        height: 40,
                        width: 150,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Center(
                                child: Html(data: AppLocalizations.of(context).translateWithArgs(
                                    "pager_label", [_currentPage.toString(), _totalPages.toString()]),
                                    style: {
                                      "html": Style(
                                          backgroundColor: Colors.white,
                                          color: Colors.black,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w100),
                                      "b": Style(fontWeight: FontWeight.w700),
                                    }))),
                      ),
                      ZButton(
                        minWidth: 40,
                        height: 40,
                        key: _btnRightKey,
                        iconData: Icons.arrow_forward_ios,
                        iconColor: Colors.blue,
                        iconSize: 30,
                        clickHandler: _onNextPage,
                        startDisabled: true,
                      )
                    ],
                  )
              )
            ],
          )
        ],
      )
    );
  }

}