import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/apps/profile/videos/profile_video_thumb.dart';
import 'package:zoo_flutter/models/video/user_video_model.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/apps/profile/videos/profile_videos_page.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class ProfileVideos extends StatefulWidget{
  ProfileVideos({Key key,this.userInfo, this.myWidth, this.videosNum, this.isMe}) : super(key: key);

  final UserInfo userInfo;
  final int videosNum;
  final double myWidth;
  final bool isMe;

  ProfileVideosState createState() => ProfileVideosState(key: key);
}

class ProfileVideosState extends State<ProfileVideos>{
  ProfileVideosState({Key key});

  RPC _rpc;
  int _currentServicePage = 1;
  int _serviceRecsPerPageFactor = 5;

  int _cols = 6;
  int _rows = 3;
  int _itemsPerPage = 18;

  PageController _pageController;
  int _fetchedPagesNum = 0;
  int _totalPages = 0;
  int _currentPageIndex = 1;

  int _totalVideosNum = 0;

  bool _dataFetched = false;

  List<List<UserVideoModel>> _pagesData = [];
  GlobalKey<ZButtonState> _previousPageButtonKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _nextPageButtonKey = GlobalKey<ZButtonState>();

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

  _onThumbClickHandler(String videoId) {
    print("lets open:" + videoId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  _getVideos({bool addMore = false}) async {
    print("getVideos");
    if (!addMore) {
      _currentPageIndex = 1;
      _currentServicePage = 1;
    }

    var options = {};
    options["recsPerPage"] = _serviceRecsPerPageFactor * _itemsPerPage;
    options["page"] = _currentServicePage;
    options["getCount"] = addMore ? 0 : 1;

    var res = await _rpc.callMethod("OldApps.Tv.getUserVideos", [ widget.userInfo.username, ""], options  );

    if (res["status"] == "ok"){
      print("VIDEO res ok");
      print(res["data"]);
      _dataFetched = true;

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

      _pagesData += _tempPagesData;
      _fetchedPagesNum = _pagesData.length;

      _updatePager();
    } else {
      print("VIDEO SRVC ERROR");
      print(res["status"]);
    }
  }

  _updatePager(){
    if (_currentPageIndex == _fetchedPagesNum && _fetchedPagesNum < _totalPages){
      _currentServicePage++;
      _previousPageButtonKey.currentState.isDisabled = true;
      _nextPageButtonKey.currentState.isDisabled = true;
      _getVideos(addMore: true);
    } else {
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
    _nextPageButtonKey = GlobalKey<ZButtonState>();
    _previousPageButtonKey = GlobalKey<ZButtonState>();

    _pageController = PageController();

    _rpc = RPC();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: widget.myWidth,
            height: 40,
            padding: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblVideos", [widget.videosNum.toString()]),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)
                ),
                Expanded(child: Container()),
               ZButton(
                  minWidth : 40,
                  height:30,
                  key: _previousPageButtonKey,
                  iconData: Icons.arrow_back_ios,
                  iconColor: Colors.blue,
                  iconSize: 30,
                  clickHandler: _onScrollLeft,
                  startDisabled: true,
                ),
                _totalPages == 0 ? Container() :Container(
                  width: 175,
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
                    minWidth : 40,
                    height:30,
                    key: _nextPageButtonKey,
                    iconData: Icons.arrow_forward_ios,
                    iconColor: Colors.blue,
                    iconSize: 30,
                    clickHandler: _onScrollRight
                )
              ],
            )
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(bottom: 10),
            //  width: widget.myWidth,
            // height: 200,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border: Border.all(color: Color(0xff9598a4), width: 2),
                borderRadius: BorderRadius.circular(9)),
            child: !_dataFetched ? Container() : widget.videosNum == 0
                ? Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                    child: Text(
                        widget.isMe
                            ? AppLocalizations.of(context)
                            .translate("app_profile_youHaveNoVideos")
                            : AppLocalizations.of(context)
                            .translateWithArgs("app_profile_noVideos",
                            [widget.userInfo.username]),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))))
                : Column(
              children: [
                Container(
                    width: widget.myWidth,
                    height: _rows * (ProfileVideoThumb.size.height + 10),
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child:
                        PageView.builder(
                            itemBuilder: (BuildContext context, int index){
                              return ProfileVideosPage(
                                pageData: _pagesData[index],
                                rows: _rows,
                                cols: _cols,
                                myWidth: widget.myWidth - 20,
                                onClickHandler:(int videoId){
                                  PopupManager.instance.show(context: context, popup: PopupType.VideoViewer, options: { "username": widget.userInfo.username, "photoId" : videoId},
                                      callbackAction: (v){});
                                },
                              );
                            },
                            pageSnapping: true,
                            scrollDirection: Axis.horizontal,
                            controller: _pageController,
                            itemCount: _totalPages
                        )
                    )
                )
              ],
            )
        )
      ],
    );
  }
}