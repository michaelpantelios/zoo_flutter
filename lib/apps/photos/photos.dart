import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/photos/photo_thumb.dart';

class Photos extends StatefulWidget{
  Photos();

  PhotosState createState() => PhotosState();
}

class PhotosState extends State<Photos>{
  PhotosState();

  Size _appSize = DataMocker.apps["photos"].size;
  int photoRows = 4;
  int photoCols = 3;
  int currentPhotosPage;
  int currentStartIndex;
  int totalPages;
  int pageSize;
  bool openPhotoSelf = true;

  List<PhotoThumbData> photosData;
  List<TableRow> photoRowsList;
  List<GlobalKey<PhotoThumbState>> thumbKeys;
  GlobalKey<ZButtonState> nextPageButtonKey;
  GlobalKey<ZButtonState> previousPageButtonKey;

  uploadCameraPhoto(){}
  uploadFilePhoto(){}

  onPreviousPage(){
    print("goBack");
    if (currentPhotosPage == 1) return;
    setState(() {
      currentPhotosPage--;
      currentStartIndex-=pageSize;
      updatePhotos(null);
    });
  }

  onNextPage(){
    print("goNext");
    if (currentPhotosPage == totalPages) return;
    setState(() {
      currentPhotosPage++;
      currentStartIndex+=pageSize;
      print("currentPhotosPage = "+currentPhotosPage.toString());
      print("currentStartIndex = "+currentStartIndex.toString());
      updatePhotos(null);
    });
  }

  updatePager(){
    previousPageButtonKey.currentState.setDisabled(currentPhotosPage == 1);
    nextPageButtonKey.currentState.setDisabled(currentPhotosPage == totalPages);
  }

  updatePhotos(_){
    if (photosData.length == 0) return;
    for (int i=0; i < pageSize; i++){
      print("i = "+i.toString());
      print("i + currentStartIndex = "+(i + currentStartIndex).toString());
      if (i+currentStartIndex < photosData.length)
        thumbKeys[i].currentState.update(photosData[i+currentStartIndex]);
      else thumbKeys[i].currentState.clear();
    }
    updatePager();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(updatePhotos);
    nextPageButtonKey = new GlobalKey<ZButtonState>();
    previousPageButtonKey = new GlobalKey<ZButtonState>();

    photosData = new List<PhotoThumbData>();
    for (int i=0; i<38; i++){
      photosData.add(new PhotoThumbData(id : i.toString(), photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png", isMain: i == 4));
    }
    pageSize = photoRows * photoCols;
    currentStartIndex = 0;
    totalPages = (38 / pageSize).ceil();
    currentPhotosPage = 1;

    thumbKeys = new List<GlobalKey<PhotoThumbState>>();
    photoRowsList = new List<TableRow>();
    for (int i=0; i<photoRows; i++){
      List<TableCell> cells = new List<TableCell>();
      for (int j=0; j<photoCols; j++) {
        GlobalKey<PhotoThumbState> theKey = new GlobalKey<PhotoThumbState>();
        cells.add(new TableCell(child: PhotoThumb(key : theKey)));
        thumbKeys.add(theKey);
      }
      TableRow row = new TableRow(children: cells);
      photoRowsList.add(row);
    }

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    print("photosData.length = "+photosData.length.toString());
    print("thumbKeys.length = "+thumbKeys.length.toString());
    String pagingText = AppLocalizations.of(context).translate("app_photos_lblPage")
        + " "
        + currentPhotosPage.toString()
        + " "
        + AppLocalizations.of(context).translate("app_photos_lblFrom")
        + " "
        + totalPages.toString();

    return
      Container(
      color: Theme.of(context).canvasColor,
      height:_appSize.height-4,
      width: _appSize.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: _appSize.width - 220,
              // height: _appSize.height,
              child: photosData.length == 0 ?
              Center(
                child: Text(AppLocalizations.of(context).translate("app_photos_noPhotos"),
                style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)
              )
              : Table(
                children: photoRowsList,
              )
          ),
          SizedBox(width:5),
          Container(
            width: 200,
            height: _appSize.height - 10,
            child: Column(
              children: [
                ZButton(
                  label : AppLocalizations.of(context).translate("app_photos_btnUploadCamera"),
                  clickHandler: uploadCameraPhoto,
                  buttonColor: Colors.white,
                  iconData: Icons.camera,
                  iconColor: Colors.orange,
                  iconSize: 25,
                ),
                SizedBox(height: 10),
                ZButton(
                  label: AppLocalizations.of(context).translate("app_photos_btnUpload"),
                  clickHandler: uploadFilePhoto,
                  buttonColor: Colors.white,
                  iconData: Icons.arrow_circle_up,
                  iconColor: Colors.blue,
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
                            onChanged: (value){ setState(() {
                              openPhotoSelf = value;
                            }); },
                            value: openPhotoSelf,
                            selected: openPhotoSelf,
                            title: Text(AppLocalizations.of(context).translate("app_photos_chkOpenSelf"),
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.left,
                            ),
                          controlAffinity: ListTileControlAffinity.leading,
                        )
                      ),

                    ],
                  )
                ),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ZButton(
                          key: previousPageButtonKey,
                          clickHandler: onPreviousPage,
                          iconData: Icons.arrow_back,
                          iconColor: Colors.black,
                          iconSize: 20,
                      ),
                      Container(
                        height: 30,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Center(child: Text( pagingText,
                              style: Theme.of(context).textTheme.bodyText1))
                        ),
                      ),
                      ZButton(
                          key: nextPageButtonKey,
                          clickHandler: onNextPage,
                          iconData: Icons.arrow_forward,
                          iconColor: Colors.black,
                          iconSize: 20,
                      )
                    ],
                  )
                )
              ],
            )
          )
        ],
      )
    );
  }
}