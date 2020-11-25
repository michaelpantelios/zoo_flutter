import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_bullets_pager.dart';

class ZRecordSet extends StatefulWidget{
  ZRecordSet({Key key,
    @required this.rowsNum,
    @required this.colsNum,
    @required this.zeroItemsMessage,
    @required this.rowsList,
    @required this.thumbKeys,
  }) : super(key: key);

  final List<TableRow> rowsList;
  final List thumbKeys;
  final int rowsNum;
  final int colsNum;
  final String zeroItemsMessage;

  ZRecordSetState createState() => ZRecordSetState(key: key);
}

class ZRecordSetState extends State<ZRecordSet>{
  ZRecordSetState({Key key});

  int currentPageIndex;
  int currentItemStartIndex;
  int totalPages = 0;
  int pageSize;

  List _data;
  List<TableRow> rowsList;
  List thumbKeys;

  GlobalKey<ZButtonState> nextPageButtonKey;
  GlobalKey<ZButtonState> previousPageButtonKey;
  GlobalKey<ZBulletsPagerState> bulletsPagerKey;

  _onBulletPagerClicked(int index){
    currentPageIndex = index+1;
    currentItemStartIndex = index * pageSize;
    _updateView();
  }

  _onPreviousPage(){
    print("goBack");
    if (currentPageIndex == 1) return;
    currentPageIndex--;
    currentItemStartIndex -= pageSize;
    _updateView();
  }

  _onNextPage(){
    print("goNext");
    if (currentPageIndex == totalPages) return;
    currentPageIndex++;
    currentItemStartIndex += pageSize;
    _updateView();
  }
  
  _updateView(){
    for (int i=0; i < pageSize; i++){
      if (i+currentItemStartIndex < _data.length)
        widget.thumbKeys[i].currentState.update(_data[i+currentItemStartIndex]);
      else widget.thumbKeys[i].currentState.clear();
    }
    _updatePageControls();
  }

  _updatePageControls(){
    previousPageButtonKey.currentState.setDisabled(currentPageIndex == 1);
    nextPageButtonKey.currentState.setDisabled(currentPageIndex == totalPages);
    bulletsPagerKey.currentState.setCurrentPage(currentPageIndex);
  }

  updateData(List<Object> data){
    print("RecordSet updateData");
    setState(() {
      _data+=data;

      if (_data.length == 0) {
        nextPageButtonKey.currentState.setHidden(true);
        previousPageButtonKey.currentState.setHidden(true);
        return;
      }

      totalPages = (_data.length / pageSize).ceil();
      bulletsPagerKey.currentState.initPager(totalPages);

      _updateView();
    });
  }

  getEmptyPhotosMessage(){
    return (_data.length == 0) ?
    Padding(
        padding: EdgeInsets.all(10),
        child: Center(
            child: Text(
                widget.zeroItemsMessage,
                style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)
            )
        )
    )
        : Container();
  }

  @override
  void initState() {
    super.initState();

    nextPageButtonKey = new GlobalKey<ZButtonState>();
    previousPageButtonKey = new GlobalKey<ZButtonState>();
    bulletsPagerKey = new GlobalKey<ZBulletsPagerState>();

    pageSize = widget.rowsNum * widget.colsNum;
    currentItemStartIndex = 0;
    currentPageIndex = 1;

    _data = new List();
  }

  @override
  Widget build(BuildContext context) {
    print("RecordSet build");
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZButton(
                  key: previousPageButtonKey,
                  clickHandler: _onPreviousPage,
                  iconData: Icons.arrow_back_ios,
                  iconColor: Colors.blue,
                  iconSize: 30,
                ),
                Expanded(
                  child: Table(
                    children: widget.rowsList,
                  ),
                ),
                ZButton(
                  key: nextPageButtonKey,
                  clickHandler: _onNextPage,
                  iconData: Icons.arrow_forward_ios,
                  iconColor: Colors.blue,
                  iconSize: 30,
                )
              ],
            ),
            ZBulletsPager(
                key: bulletsPagerKey,
                onBulletClickHandler: _onBulletPagerClicked
            )
          ],
        ),
        getEmptyPhotosMessage()
      ],
    );
  }
}
