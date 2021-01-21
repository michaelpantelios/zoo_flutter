import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/photoviewer/like_tracker.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';

class PhotoViewer extends StatefulWidget{
  PhotoViewer({this.size, this.data, this.setBusy, this.onClose });

  final Size size;
  final dynamic data;
  final Function(bool value) setBusy;
  final Function onClose;

  PhotoViewerState createState() => PhotoViewerState();
}

class PhotoViewerState extends State<PhotoViewer>{
  PhotoViewerState();

  int _currentServicePage = 1;
  int _serviceRecsPerPage =  20;

  RPC _rpc;
  double _controlsHeight = 55;
  double _totalPadding = 10;
  bool _photosLoaded = false;
  int _currentPhotoIndex = -1;
  int _totalPhotosNum = 0;
  List<int> _photosList;

  GlobalKey<ZButtonState> _btnPreviousKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnNextKey = GlobalKey<ZButtonState>();

  LikeTracker _likeTracker;
  bool _currentLikeValue = false;
  int _currentLikeCount = 0;

  _onPreviousPhoto(){
    _currentPhotoIndex--;
    _updatePageData();
  }

  _onNextPhoto(){
    _currentPhotoIndex++;
    print("_currentPhotoIndex = "+_currentPhotoIndex.toString());
    _updatePageData();
  }

  @override
  void initState(){
    super.initState();

    _likeTracker = new LikeTracker();
    _rpc = RPC();
    _photosList = [];

    _getPhotos();
  }

  _getPhotos({bool addMore = false}) async {
    print("_getPhotos");

    var res = await _rpc
        .callMethod("Photos.View.getUserPhotos", {"userId":widget.data["userId"]}, {"page" : _currentServicePage, "recsPerPage":_serviceRecsPerPage, "getCount": addMore ? 0 : 1} );

    if (res["status"] == "ok"){
      print("ok");
      print(res);
      if (res["data"]["count"] != null) {
        _totalPhotosNum = res["data"]["count"];
      }

      var records = res["data"]["records"];

      if (!addMore) _photosList.clear();

      for(int i=0; i<records.length; i++){
        int imageId = int.parse(records[i]["imageId"].toString());

        _photosList.add(imageId);

        if (imageId == int.parse(widget.data["photoId"].toString())) {
          _currentPhotoIndex = _photosList.length-1;
        }
      }

      print("currentPhotoIndex = "+_currentPhotoIndex.toString());

      if (_currentPhotoIndex == -1){
        _currentServicePage++;
        _getPhotos(addMore: true);
      } else {
        if (!addMore)
          _updatePageData();
        else _updatePager();
      }

    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _likeButtonHandler() async {
    var like = _likeTracker.getLike(_photosList[_currentPhotoIndex]);
    bool value = like != null ? like.value : false;

    var res = await _rpc
        .callMethod("Photos.View.likePhoto", [_photosList[_currentPhotoIndex],  ! value]);

    if (res["status"] == "ok"){
      print(res);
      var data = res["data"];
      print("data:");
      print(data);
      print("likes: ");
      print(data["likes"]);
      int likes = int.parse(data["likes"].toString());

      _likeTracker.like(_photosList[_currentPhotoIndex], ! value, likes);
      _currentLikeCount = _likeTracker.getLike(_photosList[_currentPhotoIndex])["count"];
      _updatePager();
    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _updatePageData(){

    if (_currentPhotoIndex+1 == _currentServicePage * _serviceRecsPerPage
        && _photosList.length <= (_currentPhotoIndex+1) * _currentServicePage ){
      print("reached Max");
      _currentServicePage++;
      _getPhotos(addMore: true);
    }

    _updatePager();
  }

  _updatePager(){
    print("_updatePager:");

    setState(() {
      var like = _likeTracker.getLike(_photosList[_currentPhotoIndex]);
      _currentLikeValue = like != null ? like["value"] : false;
      print("_currentLikeValue:"+_currentLikeValue.toString());

      _photosLoaded = true;
      _btnPreviousKey.currentState.setDisabled(_currentPhotoIndex == 0 || _totalPhotosNum == 1);
      _btnNextKey.currentState.setDisabled(_currentPhotoIndex+1 == _totalPhotosNum || _totalPhotosNum == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: widget.size.width,
      height: widget.size.height,
      padding: EdgeInsets.all(_totalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: widget.size.width - 2 * _totalPadding, height: widget.size.height - 2 * _totalPadding - _controlsHeight,
            child: !_photosLoaded ? Container() : Center(
                child: Image.network(
                  Utils.instance.getUserPhotoUrl(photoId: _photosList[_currentPhotoIndex].toString(),size: "normal"),
                fit: BoxFit.fitHeight)
              )
            ),
            Container(
              height: _controlsHeight,
              width: widget.size.width - 2 * _totalPadding,
              child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        SizedBox(width: 40),
                       SizedBox(width: 50),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ZButton(
                                    minWidth: 40,
                                    height: 40,
                                    key: _btnPreviousKey,
                                    iconData: Icons.arrow_back_ios,
                                    iconColor: Colors.blue,
                                    iconSize: 30,
                                    clickHandler: _onPreviousPhoto,
                                    startDisabled: true
                                ),
                                Container(
                                  height: 30,
                                  width: 140,
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Center(
                                          child: Html(data: AppLocalizations.of(context).translateWithArgs(
                                              "photo_viewer_pager", [(_currentPhotoIndex+1).toString(), _totalPhotosNum.toString()]),
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
                                  key: _btnNextKey,
                                  iconData: Icons.arrow_forward_ios,
                                  iconColor: Colors.blue,
                                  iconSize: 30,
                                  clickHandler: _onNextPhoto,
                                  startDisabled: true,
                                )
                              ],
                            )
                        ),
                        SizedBox(width: 50),
                  //       Container(
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               GestureDetector(
                  //                   onTap: (){
                  //                     _likeButtonHandler();
                  //                   },
                  //                   child: MouseRegion(
                  //                       cursor: SystemMouseCursors.click,
                  //                       child: Image.asset(_currentLikeValue ? "assets/images/photoviewer/like_on.png" : "assets/images/photoviewer/like_off.png")
                  //                   )
                  //               ),
                  //               Container(
                  //                   margin: EdgeInsets.only(top: 5),
                  //                   child: (_currentLikeValue && _currentLikeCount>0) ?
                  //                   Text(_currentLikeCount.toString() + AppLocalizations.of(context).translate("photo_viewer_likes"),
                  //                       style: TextStyle(color: Color(0xff9fbfff), fontSize: 12, fontWeight: FontWeight.normal ),
                  //                       textAlign: TextAlign.center) : Container()
                  //               )
                  //             ],
                  //           )
                  //
                  // ),
                  Spacer(),
                ],
              )
            )
        ],
      )
    );
  }




}
