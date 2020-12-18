import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/profile/photos/profile_photos_page.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/profile/photos/profile_photo_thumb.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ProfilePhotos extends StatefulWidget {
  ProfilePhotos(
      {Key key, this.userInfo, this.myWidth, this.photosNum, this.isMe})
      : super(key: key);

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

  _onScrollLeft(){
    _previousPageButtonKey.currentState.isDisabled = true;
    _pageController.previousPage(curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex--;
    });
  }

  _onScrollRight(){
    _nextPageButtonKey.currentState.isDisabled = true;
    _previousPageButtonKey.currentState.isHidden = false;
    _pageController.nextPage(curve: Curves.linear, duration: Duration(milliseconds: 500));
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
    print("_itemsPerPage= "+_itemsPerPage.toString());

    _pageController = PageController();
    _pageController.addListener(_scrollListener);

    _rpc = RPC();

    getPhotos();
  }

  getPhotos() async {
    var res = await _rpc
        .callMethod("Photos.View.getUserPhotos", {"userId":widget.userInfo.userId}, {"recsPerPage":500} );

    if (res["status"] == "ok") {
      var records = res["data"]["records"];
    _totalPages = (records.length / _itemsPerPage).ceil();
      print("records.length = "+records.length.toString());

      setState(() {
        int index = -1;
        for(int i=0; i<_totalPages; i++){
          List<int> pageItems = new List<int>();
          for(int j=0; j<_itemsPerPage; j++){
            index++;
            if (index < records.length)
              pageItems.add(records[index]["imageId"]);
          }
          _photoThumbPages.add(pageItems);
        }
      });
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
            color: Colors.orange[700],
            padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
            child: Text(
                AppLocalizations.of(context).translateWithArgs(
                    "app_profile_lblPhotos", [widget.photosNum.toString()]),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            height: 30),
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color: Colors.orange[700], width: 1),
            ),
            child: widget.photosNum == 0
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                            widget.isMe
                                ? AppLocalizations.of(context)
                                    .translate("app_profile_youHaveNoPhotos")
                                : AppLocalizations.of(context)
                                    .translateWithArgs("app_profile_noPhotos",
                                        [widget.userInfo.username]),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))))
                : Column(
                    children: [
                      Container(
                          width: widget.myWidth,
                          height: _rows * (ProfilePhotoThumb.size.height + 10)+10,
                          padding: EdgeInsets.all(5),
                          child: Center(
                              child:
                              PageView.builder(
                                  itemBuilder: (BuildContext context, int index){
                                    return ProfilePhotosPage(
                                      pageData: _photoThumbPages[index],
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            _totalPages > 1 ? ZButton(
                            key: _previousPageButtonKey,
                            iconData: Icons.arrow_back_ios,
                            iconColor: Colors.blue,
                            iconSize: 30,
                            clickHandler: _onScrollLeft,
                            startDisabled: true,
                          ) : Container(),
                          Container(
                            height: 30,
                            width: widget.myWidth / 2,
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
                              key: _nextPageButtonKey,
                              iconData: Icons.arrow_forward_ios,
                              iconColor: Colors.blue,
                              iconSize: 30,
                              clickHandler: _onScrollRight
                          ): Container()
                        ],
                      )
                    ],
                  ))
      ],
    );
  }
}
