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
import 'package:zoo_flutter/managers/popup_manager.dart';

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
  int _currentServicePage = 1;
  int _serviceRecsPerPageFactor = 5;

  int _cols = 6;
  int _rows = 3;
  int _itemsPerPage = 18;

  PageController _pageController;
  int _fetchedPagesNum = 0;
  int _totalPages = 0;
  int _currentPageIndex = 1;

  int _totalPhotosNum = 0;

  bool _dataFetched = false;

  List<List<int>> _pagesData = [];
  GlobalKey<ZButtonState> _nextPageButtonKey;
  GlobalKey<ZButtonState> _previousPageButtonKey;

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _getPhotos({bool addMore = false}) async {
    if (!addMore) {
      _currentPageIndex = 1;
      _currentServicePage = 1;
    }

    var options = {};
    options["recsPerPage"] = _serviceRecsPerPageFactor * _itemsPerPage;
    options["page"] = _currentServicePage;
    options["getCount"] = addMore ? 0 : 1;

    var res = await _rpc
        .callMethod("Photos.View.getUserPhotos", {"userId":widget.userInfo.userId}, options );

    if (res["status"] == "ok") {
      _dataFetched = true;
      print("got photos:");
      print(res);
      
      if (res["data"]["count"] != null) {
        _totalPhotosNum = res["data"]["count"];
        _totalPages = (res["data"]["count"] / _itemsPerPage).ceil();
      }

      var records = res["data"]["records"];

      int _tempPagesNum = (records.length / _itemsPerPage).ceil();

      if (!addMore) _pagesData.clear();

      List<List<int>> _tempPagesData = [];
      
      int index = -1;
      for(int i=0; i<_tempPagesNum; i++){
        List<int> pageItems = [];
        for(int j=0; j<_itemsPerPage; j++){
          index++;
          if (index < records.length)
            pageItems.add(records[index]["imageId"]);
        }
        _tempPagesData.add(pageItems);
      }

      print("_tempPagesData.length = "+ _tempPagesData.length.toString());

      _pagesData += _tempPagesData;
      _fetchedPagesNum = _pagesData.length;

      _updatePager();

    } else {
      print("ERROR");
      print(res["status"]);
    }
    return res;
  }

  _updatePager(){
    if (_currentPageIndex == _fetchedPagesNum && _fetchedPagesNum < _totalPages){
      _currentServicePage++;
      _previousPageButtonKey.currentState.isDisabled = true;
      _nextPageButtonKey.currentState.isDisabled = true;
      _getPhotos(addMore: true);
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
    _getPhotos();
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
              Text(
                AppLocalizations.of(context).translateWithArgs(
                    "app_profile_lblPhotos", [widget.photosNum.toString()]),
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
                iconSize: 25,
                clickHandler: _onScrollLeft,
                startDisabled: true,
              ),
              _totalPages == 0 ? Container() : Container(
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
                iconSize: 25,
                clickHandler: _onScrollRight
              )
            ],
          )
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border: Border.all(color: Color(0xff9598a4), width: 2),
              borderRadius: BorderRadius.circular(9)),
            child: !_dataFetched ? Container() : widget.photosNum == 0
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
                                    return  ProfilePhotosPage(
                                        pageData: _pagesData[index],
                                        rows: _rows,
                                        cols: _cols,
                                        myWidth: widget.myWidth - 20,
                                        onClickHandler:(int photoId){
                                          PopupManager.instance.show(context: context, popup: PopupType.PhotoViewer, options: { "userId": widget.userInfo.userId, "photoId" : photoId},
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
                      ),
                    ],
                  ))
      ],
    );
  }
}
