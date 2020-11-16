import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/photos/camera_photo_thumb.dart';

class PhotoCameraUpload extends StatefulWidget{
  PhotoCameraUpload();

  PhotoCameraUploadState createState() => PhotoCameraUploadState();
}

class PhotoCameraUploadState extends State<PhotoCameraUpload>{
  PhotoCameraUploadState();

  Size _appSize = DataMocker.apps["photoCameraUpload"].size;
  GlobalKey<ZButtonState> photoCaptureButtonKey;
  GlobalKey<ZButtonState> photoCaptureAgainButtonKey;
  GlobalKey<ZButtonState> savePhotoButtonKey;

  GlobalKey<CameraPhotoThumbState> photoThumb1Key;
  GlobalKey<CameraPhotoThumbState> photoThumb2Key;
  GlobalKey<CameraPhotoThumbState> photoThumb3Key;

  Map<String, GlobalKey<CameraPhotoThumbState>> cameraPhotoThumbs;

  int photosTaken = 0;

  onPhotoCaptureHandler(){}

  onPhotoSaveHandler(){}

  onCameraThumbTapHandler(String thumbId){
    print("id = "+thumbId);
    cameraPhotoThumbs.forEach((key, value) => value.currentState.setSelected(key == thumbId) );
  }

  @override
  void initState() {
    GlobalKey<ZButtonState> photoCaptureButtonKey = new GlobalKey<ZButtonState>();
    GlobalKey<ZButtonState> photoCaptureAgainButtonKey = new GlobalKey<ZButtonState>();
    GlobalKey<ZButtonState> savePhotoButtonKey = new GlobalKey<ZButtonState>();

    photoThumb1Key = new GlobalKey<CameraPhotoThumbState>();
    photoThumb2Key = new GlobalKey<CameraPhotoThumbState>();
    photoThumb3Key = new GlobalKey<CameraPhotoThumbState>();

    cameraPhotoThumbs = new Map<String, GlobalKey<CameraPhotoThumbState>>();
    cameraPhotoThumbs["thumb1"] = photoThumb1Key;
    cameraPhotoThumbs["thumb2"] = photoThumb2Key;
    cameraPhotoThumbs["thumb3"] = photoThumb3Key;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      height:_appSize.height-4,
      width: _appSize.width,
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black38, width: 1),
              ),
            width: _appSize.width - 10,
            height: 380,
            child: Icon(Icons.face, size: 350, color: Colors.green)
          ),
          SizedBox(height: 5),
          photosTaken == 0 ? Container(
            width: _appSize.width - 10,
            height: 40,
            child: ZButton(
              key: photoCaptureButtonKey,
              clickHandler: onPhotoCaptureHandler,
              buttonColor: Colors.white,
              icon: Icons.camera_alt,
              iconColor: Colors.blue,
              iconSize: 25,
              label: AppLocalizations.of(context).translate("app_photo_camera_upload_btnCapture"),
              labelStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            ) : Container(
              width: _appSize.width - 10,
              height: 40,
              child: ZButton(
              key: photoCaptureAgainButtonKey,
              clickHandler: onPhotoCaptureHandler,
              buttonColor: Colors.white,
              icon: Icons.flip_camera_ios_outlined,
              iconColor: Colors.blue,
              iconSize: 25,
              label: AppLocalizations.of(context).translate("app_photo_camera_upload_captureAgain"),
              labelStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            )
          ),
          SizedBox(height: 5),
          Container(
              width: _appSize.width - 10,
              height: 40,
              child: ZButton(
                key: savePhotoButtonKey,
                clickHandler: onPhotoSaveHandler,
                buttonColor: Colors.white,
                icon: Icons.save,
                iconColor: Colors.orangeAccent,
                iconSize: 25,
                label: AppLocalizations.of(context).translate("app_photo_camera_upload_btnSave"),
                labelStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
              )
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
                width: _appSize.width - 20,
                child: Row(
                  children: [
                    Expanded(
                        child: CameraPhotoThumb(key: photoThumb1Key, id: "thumb1" , onClickHandler: onCameraThumbTapHandler)
                    ),
                    SizedBox(width: 5),
                    Expanded(
                        child: CameraPhotoThumb(key: photoThumb2Key, id: "thumb2" , onClickHandler: onCameraThumbTapHandler)
                    ),
                    SizedBox(width: 5),
                    Expanded(
                        child: CameraPhotoThumb(key: photoThumb3Key, id: "thumb3" , onClickHandler: onCameraThumbTapHandler)
                    ),
                  ],
                )
            )
          )
        ],
      )
    );
  }
}