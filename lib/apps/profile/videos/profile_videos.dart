import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/apps/profile/videos/profile_video_thumb.dart';
import 'package:zoo_flutter/models/video/user_video_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/apps/profile/videos/profile_videos_page.dart';

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
  List<UserVideoInfo> _userVideos;
  int _cols;
  int _rows = 3;
  int _itemsPerPage;
  double _pageWidth;

  int _currentPageIndex = 1;
  int _totalPages = 0;

  int scrollFactor = 1;
  PageController _pageController;

  List<List<UserVideoInfo>> _videoThumbsPages = new List<List<UserVideoInfo>>();

  GlobalKey<ZButtonState> _previousPageButtonKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _nextPageButtonKey = GlobalKey<ZButtonState>();

  onScrollLeft(){
    _pageController.animateTo(_pageController.offset - _pageWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex--;
    });
  }

  onScrollRight(){
    _previousPageButtonKey.currentState.isHidden = false;
    _pageController.animateTo(_pageController.offset + _pageWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex++;
    });
  }

  _scrollListener() {
    if (_pageController.offset >= _pageController.position.maxScrollExtent &&
        !_pageController.position.outOfRange) {
      setState(() {
        _nextPageButtonKey.currentState.isDisabled = true;
      });
    }

    if (_pageController.offset < _pageController.position.maxScrollExtent && _pageController.offset > _pageController.position.minScrollExtent)
      setState(() {
        _nextPageButtonKey.currentState.isDisabled = false;
        _previousPageButtonKey.currentState.isDisabled = false;
      });

    if (_pageController.offset <= _pageController.position.minScrollExtent &&
        !_pageController.position.outOfRange) {
      setState(() {
        _previousPageButtonKey.currentState.isDisabled = true;
      });
    }
  }

  _onThumbClickHandler(String videoId) {
    print("lets open:" + videoId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _nextPageButtonKey = GlobalKey<ZButtonState>();
    _previousPageButtonKey = GlobalKey<ZButtonState>();

    _userVideos = new List<UserVideoInfo>();

    _cols = (widget.myWidth / ProfileVideoThumb.size.width).floor();
    _itemsPerPage = _cols * _rows;

    _pageController = PageController();
    _pageController.addListener(_scrollListener);

    _rpc = RPC();

    getVideos();
  }

  getVideos() async {
    print("getVideos");
    var res = await _rpc.callMethod("OldApps.Tv.getUserVideos", widget.userInfo.username.toString());

    if (res["status"] == "ok"){
      print("VIDEO res ok");
      print(res["data"]);
      var records = res["data"]["records"];
      _totalPages = (records.length / _itemsPerPage).ceil();
      print("records.length = "+records.length.toString());

      int index = -1;
      for(int i=0; i<_totalPages; i++){
        List<UserVideoInfo> pageItems = new List<UserVideoInfo>();
        for(int j=0; j<_itemsPerPage; j++){
          index++;
          if (index < records.length)
            pageItems.add(UserVideoInfo.fromJSON(records[index]));
        }
        _videoThumbsPages.add(pageItems);
      }

      setState(() {});
    } else {
      print("VIDEO SRVC ERROR");
      print(res["status"]);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: widget.myWidth,
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
                _totalPages > 1 ? ZButton(
                  minWidth : 40,
                  height:30,
                  key: _previousPageButtonKey,
                  iconData: Icons.arrow_back_ios,
                  iconColor: Colors.blue,
                  iconSize: 30,
                  clickHandler: onScrollLeft,
                  startDisabled: true,
                ) : Container(),
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
                _totalPages > 1 ? ZButton(
                    minWidth : 40,
                    height:30,
                    key: _nextPageButtonKey,
                    iconData: Icons.arrow_forward_ios,
                    iconColor: Colors.blue,
                    iconSize: 30,
                    clickHandler: onScrollRight
                ): Container()
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
            child: widget.videosNum == 0
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
                                pageData: _videoThumbsPages[index],
                                rows: _rows,
                                cols: _cols,
                                myWidth: widget.myWidth - 20,
                                onClickHandler:(int photoId){},
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