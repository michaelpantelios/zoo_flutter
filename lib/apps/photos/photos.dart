import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/ZButton.dart';
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

  List<PhotoThumbData> photosData;
  List<TableRow> photoRowsList;
  List<GlobalKey<PhotoThumbState>> thumbKeys;

  cameraPhotoHandler(){}
  filePhotoHandler(){}

  onPreviousPage(){
    print("goBack");
  }

  onNextPage(){
    print("goNext");
    for (int i=currentStartIndex; i< currentStartIndex + pageSize; i++){
      thumbKeys[i].currentState.update(photosData[i]);
    }
  }

  @override
  void initState() {
    photosData = new List<PhotoThumbData>();
    for (int i=0; i<38; i++){
      photosData.add(new PhotoThumbData(id : i.toString(), photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png", isMain: i == 4 || i == 13));
    }
    pageSize = photoRows * photoCols;
    currentStartIndex = 0;
    totalPages = (38 / pageSize).floor();
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



    return Container(
      color: Theme.of(context).canvasColor,
      height:_appSize.height-4,
      width: _appSize.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: _appSize.width - 220,
              // height: _appSize.height,
              child: Table(
                children: photoRowsList,
              )
          ),
          SizedBox(width:5),
          Container(
            width: 200,
            height: _appSize.height - 10,
            child: Column(
              children: [
                  zButton(text: AppLocalizations.of(context).translate("app_photos_btnUploadCamera"),
                      clickHandler: cameraPhotoHandler,
                    icon: Icon(Icons.camera, color: Colors.orange, size: 25)
                  ),
                SizedBox(height: 10),
                zButton(text: AppLocalizations.of(context).translate("app_photos_btnUpload"),
                    clickHandler: cameraPhotoHandler,
                    icon: Icon(Icons.arrow_circle_up, color: Colors.blue, size: 25)
                ),
                Expanded(child: Container()),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       zButton(
                              clickHandler: onPreviousPage,
                              icon: Icon(Icons.arrow_back, color: Colors.black, size: 20)
                          ),
                      Container(
                        height: 30,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Center(child: Text( pagingText,
                              style: Theme.of(context).textTheme.bodyText1))
                        ),
                      ),
                      zButton(
                            clickHandler: onNextPage,
                            icon: Icon(Icons.arrow_forward, color: Colors.black, size: 20)
                        ),
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