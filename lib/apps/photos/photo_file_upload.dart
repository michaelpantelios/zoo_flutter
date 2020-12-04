import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class PhotoFileUpload extends StatefulWidget {
  PhotoFileUpload();

  PhotoFileUploadState createState() => PhotoFileUploadState();
}

class PhotoFileUploadState extends State<PhotoFileUpload>{
  PhotoFileUploadState();

  Size _appSize = DataMocker.apps["photoFileUpload"].size;

  TextEditingController titleFieldController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  //todo change it for file upload
  TextEditingController fileFieldController = TextEditingController();
  FocusNode fileFocusNode = FocusNode();

  GlobalKey<ZButtonState> browseButtonKey;
  GlobalKey<ZButtonState> uploadButtonKey;

  onBrowseHandler(){}

  onUploadHandler(){}

  @override
  void initState() {
    // TODO: implement initState
    browseButtonKey = new GlobalKey<ZButtonState>();
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
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 20, left: 5, right: 5),
            child: zTextField(context, 
                _appSize.width, 
                titleFieldController,
                titleFocusNode, 
                AppLocalizations.of(context).translate("app_photos_lblSingleUploadTitle"))
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40, left: 5, right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              zTextField(context,
                  _appSize.width * 0.7,
                  fileFieldController,
                  fileFocusNode,
                  AppLocalizations.of(context).translate("app_photos_lblSingleUploadFile")
              ),
              Container(
                width: _appSize.width * 0.25,
                child: ZButton(
                    key: browseButtonKey,
                    buttonColor: Colors.white,
                    clickHandler: onBrowseHandler,
                    label: AppLocalizations.of(context).translate("app_photos_btnBrowse"),
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    iconData: Icons.insert_drive_file,
                    iconColor: Colors.blue,
                    iconPosition: ZButtonIconPosition.left
                ),
              )
            ],
           )
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(Icons.timelapse, color: Colors.green, size: 20)
                        ),
                        Text(AppLocalizations.of(context).translate("app_photos_lblEstimatedTime"),
                          style: Theme.of(context).textTheme.bodyText1)
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                            width: 30,
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(Icons.speed, color: Colors.orange, size: 20)
                        ),
                        Text(AppLocalizations.of(context).translate("app_photos_lblCurrentSpeed"),
                                style: Theme.of(context).textTheme.bodyText1)
                      ],
                    )
                  ],
                ),
                Expanded(child: Container()),
                Container(
                  width: 140,
                  height: 50,
                  child: ZButton(
                    key: uploadButtonKey,
                    clickHandler: onUploadHandler,
                    buttonColor: Colors.white,
                    iconData: Icons.upload_rounded,
                    iconSize: 25,
                    iconColor: Colors.green,
                    label: AppLocalizations.of(context).translate("app_photos_file_upload_btnUpload")
                  )
                )
              ],
            ),
          )
        ],
      )
    );
  }
}