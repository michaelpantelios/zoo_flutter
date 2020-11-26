import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_bullets_pager.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class ZRecordSet extends StatefulWidget {
  ZRecordSet(
      {Key key,
      @required this.rowsNum,
      @required this.colsNum,
      @required this.data,
      @required this.zeroItemsMessage,
      @required this.rowsList,
      @required this.thumbKeys,
      this.showBullets = true});

  final int rowsNum;
  final int colsNum;
  final List data;
  final String zeroItemsMessage;
  final List<TableRow> rowsList;
  final List thumbKeys;
  final bool showBullets;

  ZRecordSetState createState() => ZRecordSetState();
}

class ZRecordSetState extends State<ZRecordSet> {
  ZRecordSetState();

  int currentPageIndex;
  int currentItemStartIndex;
  int totalPages = 0;
  int pageSize;
  String pagerLabelString = "";

  List<TableRow> rowsList;

  GlobalKey<ZButtonState> nextPageButtonKey;
  GlobalKey<ZButtonState> previousPageButtonKey;
  GlobalKey<ZBulletsPagerState> bulletsPagerKey;

  _onBulletPagerClicked(int index) {
    currentPageIndex = index + 1;
    currentItemStartIndex = index * pageSize;
    _updateView(null);
  }

  _onPreviousPage() {
    print("goBack");
    if (currentPageIndex == 1) return;
    currentPageIndex--;
    currentItemStartIndex -= pageSize;
    _updateView(null);
  }

  _onNextPage() {
    print("goNext");
    if (currentPageIndex == totalPages) return;
    currentPageIndex++;
    currentItemStartIndex += pageSize;
    _updateView(null);
  }

  _updateView(_) {
    for (int i = 0; i < pageSize; i++) {
      if (i + currentItemStartIndex < widget.data.length)
        widget.thumbKeys[i].currentState
            .update(widget.data[i + currentItemStartIndex]);
      else
        widget.thumbKeys[i].currentState.clear();
    }
    _updatePageControls();
  }

  _updatePageControls() {
    previousPageButtonKey.currentState.setDisabled(currentPageIndex == 1);
    nextPageButtonKey.currentState.setDisabled(currentPageIndex == totalPages);
    if (widget.showBullets)
      bulletsPagerKey.currentState.setCurrentPage(currentPageIndex);
    else
      setState(() {
        pagerLabelString = AppLocalizations.of(context).translateWithArgs(
            "pager_label",
            [currentPageIndex.toString(), totalPages.toString()]);
      });
  }

  getEmptyPhotosMessage() {
    return (widget.data.length == 0)
        ? Padding(
            padding: EdgeInsets.all(10),
            child: Center(
                child: Text(widget.zeroItemsMessage,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))))
        : Container();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_updateView);
    super.initState();

    nextPageButtonKey = new GlobalKey<ZButtonState>();
    previousPageButtonKey = new GlobalKey<ZButtonState>();
    if (widget.showBullets)
      bulletsPagerKey = new GlobalKey<ZBulletsPagerState>();

    pageSize = widget.rowsNum * widget.colsNum;
    currentItemStartIndex = 0;
    currentPageIndex = 1;

    if (widget.data.length == 0) {
      nextPageButtonKey.currentState.setHidden(true);
      previousPageButtonKey.currentState.setHidden(true);
    } else {
      totalPages = (widget.data.length / pageSize).ceil();
    }
  }

  @override
  Widget build(BuildContext context) {
    pagerLabelString = AppLocalizations.of(context).translateWithArgs(
        "pager_label", [currentPageIndex.toString(), totalPages.toString()]);

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
            widget.showBullets
                ? ZBulletsPager(
                    key: bulletsPagerKey,
                    pagesNumber: totalPages,
                    onBulletClickHandler: _onBulletPagerClicked)
                : Container(
                    height: 30,
                    width: 120,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                            child: Html(data: pagerLabelString, style: {
                          "html": Style(
                              backgroundColor: Colors.white,
                              color: Colors.black,
                          textAlign: TextAlign.center),
                        }))),
                  )
          ],
        ),
        getEmptyPhotosMessage()
      ],
    );
  }
}
