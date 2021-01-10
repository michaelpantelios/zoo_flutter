import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:zoo_flutter/apps/profile/photos/profile_photo_thumb.dart';
import 'package:zoo_flutter/apps/profile/photos/profile_photos_page.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ProfilePhotos extends StatefulWidget {
  ProfilePhotos({Key key, this.userInfo, this.myWidth, this.photosNum, this.isMe}) : super(key: key);

  final UserInfo userInfo;
  final int photosNum;
  final double myWidth;
  final bool isMe;

  ProfilePhotosState createState() => ProfilePhotosState(key: key);
}

class ProfilePhotosState extends State<ProfilePhotos> {
  ProfilePhotosState({Key key});

  RPC _rpc;
  List<String> _photoIds;
  int _cols;
  int _rows = 3;
  int _itemsPerPage;

  int _currentPageIndex = 1;
  int _totalPages = 0;

  PageController _pageController;

  List<List<int>> _photoThumbPages = new List<List<int>>();

  GlobalKey<ZButtonState> _nextPageButtonKey;
  GlobalKey<ZButtonState> _previousPageButtonKey;

  _onScrollLeft() {
    _previousPageButtonKey.currentState.isDisabled = true;
    _pageController.previousPage(curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex--;
    });
  }

  _onScrollRight() {
    _nextPageButtonKey.currentState.isDisabled = true;
    _previousPageButtonKey.currentState.isHidden = false;
    _pageController.nextPage(curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex++;
    });
  }

  _scrollListener() {
    if (_pageController.offset >= _pageController.position.maxScrollExtent && !_pageController.position.outOfRange) {
      setState(() {
        _nextPageButtonKey.currentState.isDisabled = true;
      });
    }

    if (_pageController.offset < _pageController.position.maxScrollExtent && _pageController.offset > _pageController.position.minScrollExtent)
      setState(() {
        _nextPageButtonKey.currentState.isDisabled = false;
        _previousPageButtonKey.currentState.isDisabled = false;
      });

    if (_pageController.offset <= _pageController.position.minScrollExtent && !_pageController.position.outOfRange) {
      setState(() {
        _previousPageButtonKey.currentState.isDisabled = true;
      });
    }
  }

  _onThumbClickHandler(String photoId) {
    print("lets open:" + photoId);
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

    _photoIds = new List<String>();
    _cols = (widget.myWidth / ProfilePhotoThumb.size.width).floor();
    _itemsPerPage = _cols * _rows;
    print("_itemsPerPage= " + _itemsPerPage.toString());

    _pageController = PageController();
    _pageController.addListener(_scrollListener);

    _rpc = RPC();

    getPhotos();
  }

  getPhotos() async {
    var res = await _rpc.callMethod("Photos.View.getUserPhotos", {"userId": widget.userInfo.userId}, {"recsPerPage": 500});

    if (res["status"] == "ok") {
      var records = res["data"]["records"];
      _totalPages = (records.length / _itemsPerPage).ceil();
      print("records.length = " + records.length.toString());

      int index = -1;
      for (int i = 0; i < _totalPages; i++) {
        List<int> pageItems = new List<int>();
        for (int j = 0; j < _itemsPerPage; j++) {
          index++;
          if (index < records.length) pageItems.add(records[index]["imageId"]);
        }
        _photoThumbPages.add(pageItems);
      }

      setState(() {});
    } else {
      print("ERROR");
      print(res["status"]);
    }
    return res;
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
                Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblPhotos", [widget.photosNum.toString()]), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w500)),
                Expanded(child: Container()),
                _totalPages > 1
                    ? ZButton(
                        minWidth: 40,
                        height: 30,
                        key: _previousPageButtonKey,
                        iconData: Icons.arrow_back_ios,
                        iconColor: Colors.blue,
                        iconSize: 25,
                        clickHandler: _onScrollLeft,
                        startDisabled: true,
                      )
                    : Container(),
                _totalPages == 0
                    ? Container()
                    : Container(
                        width: 175,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Center(
                                child: HTML.toRichText(context, AppLocalizations.of(context).translateWithArgs("pager_label", [_currentPageIndex.toString(), _totalPages.toString()]), overrideStyle: {
                              "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontWeight: FontWeight.w100),
                              "b": TextStyle(fontWeight: FontWeight.w700),
                            }))),
                      ),
                _totalPages > 1 ? ZButton(minWidth: 40, height: 30, key: _nextPageButtonKey, iconData: Icons.arrow_forward_ios, iconColor: Colors.blue, iconSize: 25, clickHandler: _onScrollRight) : Container()
              ],
            )),
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor, border: Border.all(color: Color(0xff9598a4), width: 2), borderRadius: BorderRadius.circular(9)),
            child: widget.photosNum == 0
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Text(widget.isMe ? AppLocalizations.of(context).translate("app_profile_youHaveNoPhotos") : AppLocalizations.of(context).translateWithArgs("app_profile_noPhotos", [widget.userInfo.username]),
                            style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold))))
                : Column(
                    children: [
                      Container(
                          width: widget.myWidth,
                          height: _rows * (ProfilePhotoThumb.size.height + 10) + 10,
                          padding: EdgeInsets.all(5),
                          child: Center(
                              child: PageView.builder(
                                  itemBuilder: (BuildContext context, int index) {
                                    return ProfilePhotosPage(
                                      pageData: _photoThumbPages[index],
                                      rows: _rows,
                                      cols: _cols,
                                      myWidth: widget.myWidth - 20,
                                      onClickHandler: (int photoId) {
                                        PopupManager.instance.show(context: context, popup: PopupType.PhotoViewer, options: photoId);
                                      },
                                    );
                                  },
                                  pageSnapping: true,
                                  scrollDirection: Axis.horizontal,
                                  controller: _pageController,
                                  itemCount: _totalPages))),
                    ],
                  ))
      ],
    );
  }
}
