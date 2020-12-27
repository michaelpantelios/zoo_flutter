import 'dart:core';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/videos/video_thumb.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/models/video/user_video_info.dart';
import 'package:zoo_flutter/apps/videos/videos_page.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class Videos extends StatefulWidget {
  Videos({this.username, @required this.size, this.setBusy});

  final String username;
  final Size size;
  final Function(bool value) setBusy;

  VideosState createState() => VideosState();
}

class VideosState extends State<Videos> {
  VideosState();

  RPC _rpc;
  int _servicePageIndex = 1;
  int _serviceRecsPerPage = 1;

  int _resultRows;
  int _resultCols;
  int _itemsPerPage;

  double _resultsWidth;
  double _resultsHeight;

  PageController _scrollController;
  int _totalPages = 0;
  int _currentPageIndex = 1;

  bool openVideoSelf = true;

  List<List<UserVideoInfo>> _videoThumbPages = new List<List<UserVideoInfo>>();
  GlobalKey<ZButtonState> _nextPageButtonKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _previousPageButtonKey  = GlobalKey<ZButtonState>();

  playVideo() {}
  editVideo() {}
  deleteVideo() {}
  uploadFromFile() {}


  _onScrollLeft(){
    _previousPageButtonKey.currentState.isDisabled = true;
    _scrollController.animateTo(_scrollController.offset - _resultsWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 2000));
    setState(() {
      _currentPageIndex--;
    });
  }

  _onScrollRight(){
    _nextPageButtonKey.currentState.isDisabled = true;
    _previousPageButtonKey.currentState.isHidden = false;
    _scrollController.animateTo(_scrollController.offset + _resultsWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 2000));
    setState(() {
      _currentPageIndex++;
    });
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _nextPageButtonKey.currentState.isDisabled = true;
      });
    }

    if (_scrollController.offset < _scrollController.position.maxScrollExtent && _scrollController.offset > _scrollController.position.minScrollExtent)
      setState(() {
        _nextPageButtonKey.currentState.isDisabled = false;
        _previousPageButtonKey.currentState.isDisabled = false;
      });

    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _previousPageButtonKey.currentState.isDisabled = true;
      });
    }
  }


  updatePager() {
    _previousPageButtonKey.currentState.setDisabled(_currentPageIndex == 1);
    _nextPageButtonKey.currentState.setDisabled(_currentPageIndex == _totalPages);
  }


  getVideos() async {
    var res = await _rpc.callMethod("OldApps.Tv.getUserVideos", widget.username);

    if (res["status"] == "ok") {
      print("ok");
      print(res["data"]);
      var records = res["data"]["records"];
      _totalPages = (records.length / _itemsPerPage).ceil();
      _videoThumbPages.clear();
      setState(() {
        int index = -1;
        for(int i=0; i<_totalPages; i++){
          List<UserVideoInfo> pageItems = new List<UserVideoInfo>();
          for(int j=0; j<_itemsPerPage; j++){
            index++;
            if (index < records.length)
              pageItems.add(UserVideoInfo.fromJSON(records[index]));
          }
          _videoThumbPages.add(pageItems);

        }
      });

    } else {
      print("ERROR");
      print(res["status"]);
    }
  }


  @override
  void initState() {
    super.initState();

    _resultsWidth = widget.size.width - 220;
    _resultsHeight = widget.size.height - 20;

    _scrollController = PageController();
    _scrollController.addListener(_scrollListener);

    _resultRows = (_resultsHeight / VideoThumb.size.height).floor();
    _resultCols = (_resultsWidth / VideoThumb.size.width).floor();
    _itemsPerPage = _resultRows * _resultCols;
    _serviceRecsPerPage = _itemsPerPage * 4;

    _rpc = RPC();

    getVideos();

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0xFFffffff),
      height: widget.size.height - 4,
      width: widget.size.width - 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                  width: widget.size.width - 220,
                  child: _videoThumbPages.length == 0
                      ? Center(child: Text(AppLocalizations.of(context).translate("app_photos_noPhotos"), style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center))
                      :  Container(
                      width: _resultsWidth,
                      height: _resultsHeight,
                      padding: EdgeInsets.all(5),
                      child: Center(
                          child:
                          PageView.builder(
                              itemBuilder: (BuildContext context, int index){
                                return VideosPage(
                                  pageData: _videoThumbPages[index],
                                  rows: _resultRows,
                                  cols: _resultCols,
                                  myWidth: _resultsWidth,
                                  onClickHandler:(int userId){},
                                );
                              },
                              pageSnapping: true,
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemCount: _totalPages
                          )
                      )
                  )
              ),
              Expanded(child: Container()),
              Container(
                  width: widget.size.width - 170,
                  height: 35,
                  child: Row(
                    children: [
                      Container(
                          width: 220,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            onChanged: (value) {
                              setState(() {
                                openVideoSelf = value;
                              });
                            },
                            value: openVideoSelf,
                            selected: openVideoSelf,
                            title: Text(
                              AppLocalizations.of(context).translate("app_videos_chkOpenSelf"),
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.left,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          )),
                      Expanded(child: Container()),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ZButton(
                            key: _previousPageButtonKey,
                            clickHandler: _onScrollLeft,
                            iconData: Icons.arrow_back,
                            iconColor: Colors.black,
                            iconSize: 20,
                          ),
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
                                        }
                                    )
                                )
                            ),
                          ),
                          ZButton(
                            key: _nextPageButtonKey,
                            clickHandler: _onScrollRight,
                            iconData: Icons.arrow_forward,
                            iconColor: Colors.black,
                            iconSize: 20,
                          )
                        ],
                      ))
                    ],
                  ))
            ],
          ),
          SizedBox(width: 5),
          Container(
              width: 150,
              child: Column(
                children: [
                  ZButton(
                    label: AppLocalizations.of(context).translate("app_videos_btnPlay"),
                    clickHandler: playVideo,
                    buttonColor: Colors.white,
                    iconData: Icons.play_circle_outline,
                    iconColor: Colors.green,
                    iconSize: 25,
                  ),
                  SizedBox(height: 10),
                  ZButton(
                    label: AppLocalizations.of(context).translate("app_videos_btnEdit"),
                    clickHandler: editVideo,
                    buttonColor: Colors.white,
                    iconData: Icons.edit_outlined,
                    iconColor: Colors.orange,
                    iconSize: 25,
                  ),
                  SizedBox(height: 10),
                  ZButton(
                    label: AppLocalizations.of(context).translate("app_videos_btnDelete"),
                    clickHandler: deleteVideo,
                    buttonColor: Colors.white,
                    iconData: Icons.delete,
                    iconColor: Colors.red,
                    iconSize: 25,
                  ),
                  Expanded(child: Container()),
                  ZButton(
                    label: AppLocalizations.of(context).translate("app_videos_btnUpload"),
                    clickHandler: uploadFromFile,
                    buttonColor: Colors.white,
                    iconData: Icons.file_upload,
                    iconColor: Colors.green,
                    iconSize: 25,
                  ),
                  SizedBox(height: 4)
                ],
              ))
        ],
      ),
    );
  }
}
