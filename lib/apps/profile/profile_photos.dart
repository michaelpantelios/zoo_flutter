import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/profile/profile_photo_thumb.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
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

  onScrollRight(){
    _btnLeftKey.currentState.isHidden = false;
    _scrollController.animateTo(_scrollController.offset + _pageWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex++;
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

  _onThumbClickHandler(String photoId) {
    print("lets open:" + photoId);
  }

  @override
  void initState() {
    super.initState();
    _photoIds = new List<String>();
    _cols = (widget.myWidth / ProfilePhotoThumb.size.width).floor();
    _itemsPerPage = _cols * _rows;
    _pageWidth = _cols * (ProfilePhotoThumb.size.width + 7);

    _currentPageIndex = 1;
    _totalPages = (_photoIds.length / _itemsPerPage).ceil();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    scrollFactor = _cols;

    _rpc = RPC();
  }

  getPhotos() async {
    var res = await _rpc
        .callMethod("Photos.View.getUserPhotos", [widget.userInfo.userId]);

    if (res["status"] == "ok") {
      setState(() {
        for (int i = 0; i < widget.photosNum; i++) {
          var photoItem = res["data"]["records"][i];
          _photoIds.add(photoItem["imageId"].toString());
        }

        //TODO test, remove this for production
        _photoIds += _photoIds += _photoIds += _photoIds+= _photoIds+= _photoIds;

        _totalPages = (_photoIds.length / _itemsPerPage).ceil();
      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
    return res;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.photosNum == 0) return;
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
      var res = getPhotos();
    }
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
                          height: _rows * (ProfilePhotoThumb.size.height + 10),
                          padding: EdgeInsets.all(5),
                          child: GridView.builder(
                            cacheExtent: _pageWidth,
                            physics: const NeverScrollableScrollPhysics(),
                            // primary: false,
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            itemCount: _photoIds.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new ProfilePhotoThumb(
                                  photoId: _photoIds[index],
                                  onClickHandler: _onThumbClickHandler);
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: ProfilePhotoThumb.size.height / ProfilePhotoThumb.size.width,
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
                  ))
      ],
    );
  }
}
