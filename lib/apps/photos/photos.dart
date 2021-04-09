import 'dart:core';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/photos/photos_page.dart';
import 'package:zoo_flutter/models/photos/user_photo_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'photo_file_upload.dart';

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

  int _totalPhotosNum = 0;

  bool _dataFetched = false;

  List<List<UserPhotoModel>> _pagesData = [];
  GlobalKey<ZButtonState> _nextPageButtonKey;
  GlobalKey<ZButtonState> _previousPageButtonKey;

  _setPhotoAsMain(BuildContext context, int imageId) async {
    print("lets DO SET "+imageId.toString()+" as main");
    var res = await _rpc.callMethod("Photos.Manage.setMain",
         imageId );

    if (res["status"] == "ok"){
      AlertManager.instance.showSimpleAlert(context: context,
          bodyText: AppLocalizations.of(context).translate("app_photos_setMain"));
      _getPhotos();
    } else {
      print("ERROR");
      print(res);
    }
  }

  _deletePhoto(BuildContext context, int imageId) {
    print("lets delete "+imageId.toString());
    AlertManager.instance.showSimpleAlert(context: context,
        bodyText: AppLocalizations.of(context).translate("app_photos_deletePhoto"),
        dialogButtonChoice: AlertChoices.OK_CANCEL,
        callbackAction: (r){
          if (r == 1)
            _doDeletePhoto(context, imageId);
        }
    );
  }

  _doDeletePhoto(BuildContext context, int imageId) async {
    widget.setBusy(true);
    print("lets DO DELETE "+imageId.toString());
    var res = await _rpc.callMethod("Photos.Manage.deletePhotos",
         [ imageId ]
    );

    if (res["status"] == "ok"){
     // print(res);
      AlertManager.instance.showSimpleAlert(context: context,
          bodyText: AppLocalizations.of(context).translate("app_photos_delete_success"));
      _getPhotos();
    } else {
      AlertManager.instance.showSimpleAlert(context: context,
          bodyText: AppLocalizations.of(context).translate("app_photos_deleteFailed"));

      print("ERROR");
      print(res);
    }
  }

  _uploadCameraPhoto() {
    AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("unavailable_service"));
  }

  _uploadFilePhoto() {
    PopupManager.instance.show(context: context, popup: PopupType.PhotoFileUpload, options: {
      "mode" : uploadMode.userPhoto,
       "customCallback" :
          (val) {
          print("file upload res");
          print(val);
          if (val == 1) {
            print("file uploaded, random filename =" + val.toString());
            widget.setBusy(true);
            _getPhotos();
          }
        }
      },
      callbackAction: (retValue) {}
    );
  }

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

  _getPhotos({bool addMore = false}) async {
    if (!addMore) {
      _currentPageIndex = 1;
      _currentServicePage = 1;
    }

    var options = {};
    options["recsPerPage"] = _serviceRecsPerPageFactor * _itemsPerPage;
    options["page"] = _currentServicePage;
    options["getCount"] = addMore ? 0 : 1;

    var res = await _rpc.callMethod("Photos.Manage.getMyPhotos", options);

    if (res["status"] == "ok") {
      _dataFetched = true;
      print("got photos:");
      print(res);
      if (res["data"]["count"] != null) {
        _totalPhotosNum = res["data"]["count"];
        _totalPages = (res["data"]["count"] / _itemsPerPage).ceil();
      }

      var records = res["data"]["records"];

      print("records.length = "+records.length.toString());

      int _tempPagesNum = (records.length / _itemsPerPage).ceil();

      if (!addMore) _pagesData.clear();

      List<List<UserPhotoModel>> _tempPagesData = [];

      int index = -1;
      for(int i=0; i<_tempPagesNum; i++){
        List<UserPhotoModel> pageItems = [];
        for(int j=0; j<_itemsPerPage; j++){
          index++;
          if (index < records.length)
            pageItems.add(UserPhotoModel.fromJSON(records[index]));
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
      print(res["status"]);
    }
  }

  _updatePager(){
      if (_currentPageIndex == _fetchedPagesNum && _fetchedPagesNum < _totalPages){
         _currentServicePage++;
        _previousPageButtonKey.currentState.isDisabled = true;
        _nextPageButtonKey.currentState.isDisabled = true;
        _getPhotos(addMore: true);
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
    _getPhotos();
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
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: widget.size.width - 280,
                  child: Column(
                    children: [ !_dataFetched ? Container() :
                      _pagesData.length == 0
                          ? Center(child: Text(AppLocalizations.of(context).translate("app_photos_noPhotos"), style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center))
                          : Container(
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
                                    return PhotosPage(
                                      pageData: _pagesData[index],
                                      rows: _resultRows,
                                      cols: _resultCols,
                                      myWidth: _resultsWidth,
                                      onClickHandler:(int photoId){
                                        PopupManager.instance.show(context: context, popup: PopupType.PhotoViewer, options: { "userId": widget.userId, "photoId" : photoId}, callbackAction: (v){});
                                      },
                                      onSetAsMainHandler: (int photoId){
                                        _setPhotoAsMain(context, photoId);
                                      },
                                      onDeleteHandler: (int photoId){
                                        _deletePhoto(context, photoId);
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
                        label: AppLocalizations.of(context).translate("app_photos_btnUploadCamera"),
                        labelStyle: Theme.of(context).textTheme.button,
                        clickHandler: _uploadCameraPhoto,
                        buttonColor: Colors.orange,
                        iconData: Icons.photo_camera,
                        iconColor: Colors.white,
                        iconSize: 35,
                        iconPosition: ZButtonIconPosition.right,
                      ),
                      SizedBox(height: 10),
                      ZButton(
                        minWidth: 250,
                        height: 40,
                        label: AppLocalizations.of(context).translate("app_photos_btnUpload"),
                        labelStyle: Theme.of(context).textTheme.button,
                        clickHandler: _uploadFilePhoto,
                        buttonColor: Colors.blue,
                        iconData: Icons.arrow_circle_up,
                        iconColor: Colors.white,
                        iconSize: 35,
                        iconPosition: ZButtonIconPosition.right,
                      ),
                    ],
                  )
              )
            ],
          ),
        )
        );
  }
}
