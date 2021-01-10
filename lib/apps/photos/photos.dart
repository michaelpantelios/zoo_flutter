import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:zoo_flutter/apps/photos/photo_thumb.dart';
import 'package:zoo_flutter/apps/photos/photos_page.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class Photos extends StatefulWidget {
  Photos({this.userId, @required this.size, this.setBusy});

  final int userId;
  final Size size;
  final Function(bool value) setBusy;

  PhotosState createState() => PhotosState();
}

class PhotosState extends State<Photos> {
  PhotosState();

  RPC _rpc;
  int _servicePageIndex = 1;
  int _serviceRecsPerPage = 1;

  int _resultRows;
  int _resultCols;
  int _itemsPerPage;

  double _resultsWidth;
  double _resultsHeight;

  PageController _pageController;
  int _totalPages = 0;
  int _currentPageIndex = 1;

  List<List<int>> _photoThumbPages = new List<List<int>>();
  GlobalKey<ZButtonState> _nextPageButtonKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _previousPageButtonKey = GlobalKey<ZButtonState>();

  bool _openPhotoSelf = true;

  _uploadCameraPhoto() {
    AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("unavailable_service"));
  }

  _uploadFilePhoto() {
    PopupManager.instance.show(context: context, popup: PopupType.PhotoFileUpload, callbackAction: (retValue) {});
  }

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

  getPhotos() async {
    var res = await _rpc.callMethod("Photos.View.getUserPhotos", {"userId": widget.userId}, {"recsPerPage": 500});

    if (res["status"] == "ok") {
      print("ok");
      print(res["data"]);
      var records = res["data"]["records"];
      _totalPages = (records.length / _itemsPerPage).ceil();
      _photoThumbPages.clear();
      setState(() {
        int index = -1;
        for (int i = 0; i < _totalPages; i++) {
          List<int> pageItems = new List<int>();
          for (int j = 0; j < _itemsPerPage; j++) {
            index++;
            if (index < records.length) pageItems.add(records[index]["imageId"]);
          }
          _photoThumbPages.add(pageItems);
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

    _pageController = PageController();
    _pageController.addListener(_scrollListener);

    _resultRows = (_resultsHeight / PhotoThumb.size.height).floor();
    _resultCols = (_resultsWidth / PhotoThumb.size.width).floor();
    _itemsPerPage = _resultRows * _resultCols;
    _serviceRecsPerPage = _itemsPerPage * 4;

    _rpc = RPC();

    getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFffffff),
        height: widget.size.height - 4,
        width: widget.size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: widget.size.width - 220,
                child: _photoThumbPages.length == 0
                    ? Center(child: Text(AppLocalizations.of(context).translate("app_photos_noPhotos"), style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center))
                    : Container(
                        width: _resultsWidth,
                        height: _resultsHeight,
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: PageView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return PhotosPage(
                                    pageData: _photoThumbPages[index],
                                    rows: _resultRows,
                                    cols: _resultCols,
                                    myWidth: _resultsWidth,
                                    onClickHandler: (int photoId) {
                                      PopupManager.instance.show(context: context, popup: PopupType.PhotoViewer, options: photoId);
                                    },
                                  );
                                },
                                pageSnapping: true,
                                scrollDirection: Axis.horizontal,
                                controller: _pageController,
                                itemCount: _totalPages)))),
            SizedBox(width: 5),
            Container(
                width: 200,
                margin: EdgeInsets.only(top: 10),
                height: widget.size.height - 10,
                child: Column(
                  children: [
                    ZButton(
                      minWidth: 200,
                      height: 40,
                      label: AppLocalizations.of(context).translate("app_photos_btnUploadCamera"),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      clickHandler: _uploadCameraPhoto,
                      buttonColor: Colors.orange,
                      iconData: Icons.camera,
                      iconColor: Colors.white,
                      iconSize: 25,
                    ),
                    SizedBox(height: 10),
                    ZButton(
                      minWidth: 200,
                      height: 40,
                      label: AppLocalizations.of(context).translate("app_photos_btnUpload"),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      clickHandler: _uploadFilePhoto,
                      buttonColor: Colors.blue,
                      iconData: Icons.arrow_circle_up,
                      iconColor: Colors.white,
                      iconSize: 25,
                    ),
                    Expanded(child: Container()),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 190,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              onChanged: (value) {
                                setState(() {
                                  _openPhotoSelf = value;
                                });
                              },
                              value: _openPhotoSelf,
                              selected: _openPhotoSelf,
                              title: Text(
                                AppLocalizations.of(context).translate("app_photos_chkOpenSelf"),
                                style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
                                textAlign: TextAlign.left,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            )),
                      ],
                    )),
                    Container(
                        height: 30,
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
                                      child: HTML.toRichText(context, AppLocalizations.of(context).translateWithArgs("pager_label", [_currentPageIndex.toString(), _totalPages.toString()]), overrideStyle: {
                                    "html": TextStyle(backgroundColor: Colors.white, color: Colors.black),
                                  }))),
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
        ));
  }
}
