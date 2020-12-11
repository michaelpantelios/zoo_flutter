import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/apps/profile/profile_video_thumb.dart';
import 'package:zoo_flutter/models/video/user_video_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

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

  int _currentPageIndex;
  int _totalPages = 0;

  int scrollFactor = 1;
  ScrollController _scrollController;

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  onScrollLeft(){
    _scrollController.animateTo(_scrollController.offset - _pageWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex--;
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

  onScrollRight(){
    _btnLeftKey.currentState.isHidden = false;
    _scrollController.animateTo(_scrollController.offset + _pageWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex++;
    });
  }

  _onThumbClickHandler(String videoId) {
    print("lets open:" + videoId);
  }

  @override
  void initState() {
    super.initState();
    _userVideos = new List<UserVideoInfo>();
    _cols = (widget.myWidth / ProfileVideoThumb.size.width).floor();
    _itemsPerPage = _cols * _rows;
    _pageWidth = _cols * (ProfileVideoThumb.size.width + 7);

    _currentPageIndex = 1;
    _totalPages = (_userVideos.length / _itemsPerPage).ceil();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    scrollFactor = _cols;

    _rpc = RPC();
  }

  getVideos() async {
    print("getVideos");
    var res = await _rpc.callMethod("OldApps.Tv.getUserVideos", widget.userInfo.username.toString());

    if (res["status"] == "ok"){
      print("VIDEO res ok");
      print(res["data"]);
      setState(() {
        for (int i = 0; i < widget.videosNum; i++) {
          UserVideoInfo videoItem = UserVideoInfo.fromJSON(res["data"]["records"][i]);
          _userVideos.add(videoItem);
        }

        //TODO test, remove this for production
        // _userVideos += _userVideos += _userVideos += _userVideos+= _userVideos+= _userVideos;

        _totalPages = (_userVideos.length / _itemsPerPage).ceil();
      });
    } else {
      print("VIDEO SRVC ERROR");
      print(res["status"]);
    }

    return res;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.videosNum == 0) return;
    if (!UserProvider.instance.logged) {
      print("not logged");
      // widget.onClose(
      //     PopupManager.instance.show(
      //     context: context,
      //     popup: PopupType.Login,
      //     callbackAction: (retValue) {
      //       print(retValue);
      //     },
      //   )
      // );
      //
    } else {
      print("logged");
      var res = getVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: widget.myWidth,
            color: Colors.orange[700],
            padding: EdgeInsets.only(left: 10, top:5, bottom: 5, right: 5),
            child: Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblVideos", [widget.videosNum.toString()]),
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            height: 30),
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(bottom: 10),
            //  width: widget.myWidth,
            // height: 200,
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color:Colors.orange[700], width: 1),
            ),
            child:
            widget.videosNum == 0
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
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: _userVideos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new ProfileVideoThumb(
                            videoInfo: _userVideos[index],
                            onClickHandler: _onThumbClickHandler);
                      },
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: ProfileVideoThumb.size.height / ProfileVideoThumb.size.height,
                          crossAxisCount: _rows,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _totalPages > 1 ? ZButton(
                      key: _btnLeftKey,
                      iconData: Icons.arrow_back_ios,
                      iconColor: Colors.blue,
                      iconSize: 30,
                      clickHandler: onScrollLeft,
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
                        clickHandler: onScrollRight
                    ): Container()
                  ],
                )
              ],
            )
        )
      ],
    );
  }
}