import 'dart:core';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/videos/video_thumb.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/models/video/user_video_model.dart';
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
  int _currentServicePage = 1;
  int _serviceRecsPerPageFactor = 5;

  double _controlsHeight = 80;

  int _resultRows = 3;
  int _resultCols = 4;
  int _itemsPerPage = 12;

  double _resultsWidth;
  double _resultsHeight;

  PageController _pageController;
  int _fetchedPagesNum = 0;
  int _totalPages = 0;
  int _currentPageIndex = 1;

  int _totalVideosNum = 0;

  bool _dataFetched = false;

  List<List<UserVideoModel>> _pagesData = [];
  GlobalKey<ZButtonState> _nextPageButtonKey;
  GlobalKey<ZButtonState> _previousPageButtonKey;

  _playVideo(int videoId) {


  }

  _deleteVideo(BuildContext context, int videoId) {

  }

  _uploadVideo() {}

  _onScrollLeft(){
    _pageController.previousPage(curve: Curves.linear, duration: Duration(milliseconds: 500));
    _currentPageIndex--;
    _updatePager();
  }

  _onScrollRight(){
    _pageController.nextPage(curve: Curves.linear, duration: Duration(milliseconds: 500));
    _currentPageIndex++;
    _updatePager();
  }

  updatePager() {
    _previousPageButtonKey.currentState.setDisabled(_currentPageIndex == 1);
    _nextPageButtonKey.currentState.setDisabled(_currentPageIndex == _totalPages);
  }


  _getVideos({bool addMore = false}) async {
    if (!addMore) {
      _currentPageIndex = 1;
      _currentServicePage = 1;
    }

    var options = {};
    options["recsPerPage"] = _serviceRecsPerPageFactor * _itemsPerPage;
    options["page"] = _currentServicePage;
    options["getCount"] = addMore ? 0 : 1;

    var res = await _rpc.callMethod("OldApps.Tv.getUserVideos", [ widget.username, ""], options  );

    if (res["status"] == "ok") {
      _dataFetched = true;
      print("ok");
      print(res);
      if (res["data"]["count"] != null) {
        _totalVideosNum = res["data"]["count"];
        _totalPages = (res["data"]["count"] / _itemsPerPage).ceil();
      }

      var records = res["data"]["records"];

      int _tempPagesNum = (records.length / _itemsPerPage).ceil();

      if (!addMore) _pagesData.clear();

      List<List<UserVideoModel>> _tempPagesData = [];


      int index = -1;
      for(int i=0; i<_tempPagesNum; i++){
        List<UserVideoModel> pageItems = [];
        for(int j=0; j<_itemsPerPage; j++){
          index++;
          if (index < records.length)
            pageItems.add(UserVideoModel.fromJSON(records[index]));
        }
        _tempPagesData.add(pageItems);
      }

      print("_tempPagesData.length = "+ _tempPagesData.length.toString());

      _pagesData += _tempPagesData;
      _fetchedPagesNum = _pagesData.length;
      print("_fetchedPagesNum = "+_fetchedPagesNum.toString());

      _updatePager();

    } else {
      print("ERROR");
      print(res);
    }
  }

  _updatePager(){
    if (_currentPageIndex == _fetchedPagesNum && _fetchedPagesNum < _totalPages){
      _currentServicePage++;
      _previousPageButtonKey.currentState.isDisabled = true;
      _nextPageButtonKey.currentState.isDisabled = true;
      _getVideos(addMore: true);
    } else {
      widget.setBusy(false);
      setState(() {
        _previousPageButtonKey.currentState.isDisabled =
            _currentPageIndex == 1;
        _nextPageButtonKey.currentState.isDisabled =
            _currentPageIndex == _totalPages;
      });
    }
  }

  postFrameCallback(_){
    _getVideos();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
    _resultsWidth = widget.size.width - 220;
    _resultsHeight = widget.size.height - _controlsHeight - 30;

    _pageController = PageController();

    _nextPageButtonKey = new GlobalKey<ZButtonState>();
    _previousPageButtonKey = new GlobalKey<ZButtonState>();

    _itemsPerPage = _resultRows * _resultCols;

    _rpc = RPC();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFffffff),
      height: widget.size.height,
      width: widget.size.width,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widget.size.width - 280,
              child: Column(
                children: [  !_dataFetched ? Container() :
                     _pagesData.length == 0
                      ? Center(child: Text(AppLocalizations.of(context).translate("app_videos_noVideos"), style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center))
                      :  Container(
                      width: _resultsWidth,
                      height: _resultsHeight,
                      decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(9),
                         border: Border.all(
                           color: Color(0xff9597a3),
                           width: 2,
                         )
                       ),
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child:
                          PageView.builder(
                              itemBuilder: (BuildContext context, int index){
                                return VideosPage(
                                  pageData: _pagesData[index],
                                  rows: _resultRows,
                                  cols: _resultCols,
                                  myWidth: _resultsWidth,
                                  onClickHandler:(int videoId){
                                    _playVideo(videoId);
                                  },
                                  onDeleteHandler: (int videoId){
                                    _deleteVideo(context, videoId);
                                  },
                                );
                              },
                              pageSnapping: true,
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              itemCount: _pagesData.length,
                              physics: const NeverScrollableScrollPhysics(),
                          )
                      )
                  ),
                  Container(
                      height: _controlsHeight,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ZButton(
                              minWidth: 40,
                              height: 40,
                              key: _previousPageButtonKey,
                              iconData: Icons.arrow_back_ios,
                              iconColor: Colors.blue,
                              iconSize: 30,
                              clickHandler: _onScrollLeft,
                              startDisabled: true
                          ),
                          Container(
                            height: 40,
                            width: 250,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                    child: Html(data: AppLocalizations.of(context).translateWithArgs(
                                        "pager_label", [_currentPageIndex.toString(), _totalPages.toString()]),
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
                            key: _nextPageButtonKey,
                            iconData: Icons.arrow_forward_ios,
                            iconColor: Colors.blue,
                            iconSize: 30,
                            clickHandler: _onScrollRight,
                            startDisabled: true,
                          )
                        ],
                      )
                  )
                ],
              )
            ),
            SizedBox(width: 5),
            Container(
                width: 250,
                height: widget.size.height - 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ZButton(
                      minWidth: 250,
                      height: 40,
                      label: AppLocalizations.of(context).translate("app_videos_btnUpload"),
                      labelStyle: Theme.of(context).textTheme.button,
                      clickHandler: _uploadVideo,
                      buttonColor: Colors.orange,
                      iconData: Icons.videocam,
                      iconColor: Colors.white,
                      iconSize: 35,
                      iconPosition: ZButtonIconPosition.right,
                    ),
                  ],
                )
            )
          ],
        )
      )
    );
  }
}
