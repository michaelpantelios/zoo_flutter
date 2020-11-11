import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  int photoRows = 3;
  int photoCols = 4;
  int currentPhotosPage;
  int currentStartIndex;
  int pageSize;

  List<PhotoThumbData> photosData;
  List<TableRow> photoRowsList;
  List<GlobalKey> thumbKeys;

  cameraPhotoHandler(){}
  filePhotoHandler(){}

  @override
  void initState() {
    photosData = new List<PhotoThumbData>();
    for (int i=0; i<38; i++){
      photosData.add(new PhotoThumbData(photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/d510d643afae021c4e1dbc7ce1eb3f0a.png", isMain: i == 4 || i == 13));
    }
    pageSize = photoRows * photoCols;
    currentStartIndex = 0;

    thumbKeys = new List<GlobalKey>();
    photoRowsList = new List<TableRow>();
    for (int i=0; i<photoRows; i++){
      List<TableCell> cells = new List<TableCell>();
      for (int j=0; j<photoCols; j) {
        GlobalKey key = new GlobalKey();
        PhotoThumb thumb = new PhotoThumb(key : key);
        cells.add(new TableCell(child: thumb));
        thumbKeys.add(key);
      }
      TableRow row = new TableRow(children: cells);
      photoRowsList.add(row);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      height:_appSize.height-4,
      width: _appSize.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: _appSize.width - 230,
              // height: _appSize.height,
              color: Colors.cyan[100],
              // child: Table(
              //   children: photoRowsList,
              // )
          ),
          SizedBox(width:5),
          Container(
            width: 200,
            height: _appSize.height - 15,
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
              ],
            )
          )
        ],
      )
    );
  }
}