import 'dart:io' as io;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

class PhotoFileUpload extends StatefulWidget {
  final Size size;
  PhotoFileUpload(this.size);

  PhotoFileUploadState createState() => PhotoFileUploadState();
}

class PhotoFileUploadState extends State<PhotoFileUpload> {
  PhotoFileUploadState();

  FilePickerResult result;
  File file;

  TextEditingController titleFieldController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  //todo change it for file upload
  TextEditingController fileFieldController = TextEditingController();
  FocusNode fileFocusNode = FocusNode();

  GlobalKey<ZButtonState> browseButtonKey;
  GlobalKey<ZButtonState> uploadButtonKey;

  String filePath = "";

  onBrowseHandler() async {
    result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg', 'gif']);

    if(result != null) {
      file = File(result.files[0].bytes, result.files[0].name);
      print("Filename: "+result.files[0].name);
    }

    setState(() {
      filePath = result.files[0].name;
    });
  }

  onUploadHandler() async {
    if(file !=null) {
      // Uri uri = Uri.parse('$url/xxx--xxx/images/');
      String uploadUrl  = Utils.instance.getUploadPhotoUrl(sessionKey: UserProvider.instance.sessionKey, filename: result.files[0].name);
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(
          await http.MultipartFile.fromBytes(
              'picture',
              result.files[0].bytes
          )
      );
      var res = await request.send();

      print("Upload result");
      print(res);
    }
  }

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
        height: widget.size.height - 4,
        width: widget.size.width,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 5, bottom: 20, left: 5, right: 5),
                child: zTextField(context, widget.size.width, titleFieldController, titleFocusNode, AppLocalizations.of(context).translate("app_photos_lblSingleUploadTitle"))),
            Padding(
                padding: EdgeInsets.only(bottom: 40, left: 5, right: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container( child: Text(filePath, style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.bold) )),
                    Container(
                      width: widget.size.width * 0.25,
                      child: ZButton(
                          key: browseButtonKey,
                          buttonColor: Colors.white,
                          clickHandler: onBrowseHandler,
                          label: AppLocalizations.of(context).translate("app_photos_btnBrowse"),
                          labelStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                          iconData: Icons.insert_drive_file,
                          iconColor: Colors.blue,
                          iconPosition: ZButtonIconPosition.left),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [Container(width: 30, padding: EdgeInsets.only(right: 5), child: Icon(Icons.timelapse, color: Colors.green, size: 20)), Text(AppLocalizations.of(context).translate("app_photos_lblEstimatedTime"), style: Theme.of(context).textTheme.bodyText1)],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [Container(width: 30, padding: EdgeInsets.only(right: 5), child: Icon(Icons.speed, color: Colors.orange, size: 20)), Text(AppLocalizations.of(context).translate("app_photos_lblCurrentSpeed"), style: Theme.of(context).textTheme.bodyText1)],
                      )
                    ],
                  ),
                  Expanded(child: Container()),
                  Container(width: 140, height: 50, child: ZButton(key: uploadButtonKey, clickHandler: onUploadHandler, buttonColor: Colors.white, iconData: Icons.upload_rounded, iconSize: 25, iconColor: Colors.green, label: AppLocalizations.of(context).translate("app_photos_file_upload_btnUpload")))
                ],
              ),
            )
          ],
        ));
  }
}
