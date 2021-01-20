import 'dart:io' as io;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

class PhotoFileUpload extends StatefulWidget {
  PhotoFileUpload({this.size, this.customCallback, this.onClose, this.setBusy});

  final Size size;
  final Function onClose;
  final Function setBusy;
  final Function customCallback;

  PhotoFileUploadState createState() => PhotoFileUploadState();
}

class PhotoFileUploadState extends State<PhotoFileUpload> {
  PhotoFileUploadState();

  FilePickerResult result;
  File file;
  String _randomFilename;
  var fileBytes;
  String fileName;
  FileReader reader;
  var imageFileBytes;
  RPC _rpc;

  TextEditingController titleFieldController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  //todo change it for file upload
  FocusNode fileFocusNode = FocusNode();

  GlobalKey<ZButtonState> browseButtonKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> uploadButtonKey = GlobalKey<ZButtonState>();

  String _fileName = "";

  _onBrowseHandler() async {
    result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg', 'gif']);

    if(result != null) {
      print("picked file: "+result.files.first.name);

      fileBytes = result.files[0].bytes;
      fileName = result.files[0].name;

      // print(fileBytes);

      file = File(result.files[0].bytes, result.files[0].name);
      print("created file with length:");
      print(file.size);
      
      setState(() {
        _fileName = result.files[0].name;
        uploadButtonKey.currentState.isDisabled = false;
      });


      reader = FileReader();

      reader.onLoadEnd.listen( (loadEndEvent) async {
              var _bytesData = Base64Decoder().convert(reader.result.toString().split(",").last);
              print("reader loaded");
          setState(() {
            imageFileBytes = _bytesData;
          });
        },
      );

      reader.readAsDataUrl(file);
    }
  }


  _onUploadHandler(BuildContext context) async {
    print("onUploadHandler");
    if (titleFieldController.text.length == 0){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_photos_no_title"));
      return;
    }

    if(file !=null) {
      _randomFilename = Utils.instance.randomDigitString() + ".jpg";
      print("_randomFilename: "+_randomFilename);

      String uploadUrl  = Utils.instance.getUploadPhotoUrl(sessionKey: UserProvider.instance.sessionKey, filename: _randomFilename);
      print("uploadUrl = "+uploadUrl);

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl) );

      request.files.add(
        new http.MultipartFile.fromBytes(
          'Filedata',
            // imageFileBytes,
            fileBytes,
            filename: 'temp',
            contentType: new MediaType('image', 'jpeg')
        )
      );

      var res = await request.send();
      var code = await res.stream.bytesToString();
      print(code);

      if (code == "ok"){
        _uploadNewPhoto(context);
      } else {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_photos_invalid_file"));
      }

    }
  }

  _uploadNewPhoto(BuildContext context) async {
    print("upload for: "+_randomFilename);
    print("upload for title:" + titleFieldController.text);
    var res = await _rpc.callMethod("Photos.Manage.newPhoto", [_randomFilename, titleFieldController.text]);

    if (res["status"] == "ok") {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_photo_camera_upload_uploaded"));
      widget.customCallback(1);
      setState(() {
        titleFieldController.text = "";
        _fileName = "";
      });
    } else {
      print(res);
      print("error");
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_photos_invalid_file"));
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    browseButtonKey = new GlobalKey<ZButtonState>();
    _rpc = RPC();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFffffff),
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
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26, width: 1),
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            new BoxShadow(color:  Color(0x33000000), offset: new Offset(0.0, 0.0), blurRadius: 2, spreadRadius: 2),
                          ],
                        ),
                        width: (widget.size.width / 2),
                        height: 40,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(_fileName,
                            style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.bold) )),
                    ZButton(
                          minWidth: 140,
                          height: 40,
                          key: browseButtonKey,
                          buttonColor: Colors.blue,
                          clickHandler: _onBrowseHandler,
                          label: AppLocalizations.of(context).translate("app_photos_btnBrowse"),
                          labelStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          iconData: Icons.insert_drive_file,
                          iconColor: Colors.white,
                          iconPosition: ZButtonIconPosition.left),
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
                        children: [Container(width: 30, padding: EdgeInsets.only(right: 5), child: Icon(Icons.timelapse, color: Colors.green, size: 20)), Text(AppLocalizations.of(context).translate("app_photos_lblEstimatedTime"), style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.normal))],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [Container(width: 30, padding: EdgeInsets.only(right: 5), child: Icon(Icons.speed, color: Colors.orange, size: 20)), Text(AppLocalizations.of(context).translate("app_photos_lblCurrentSpeed"), style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.normal))],
                      )
                    ],
                  ),
                  Expanded(child: Container()),
                   ZButton(
                      key: uploadButtonKey,
                      minWidth: 140,
                      height: 40,
                      clickHandler: (){
                        _onUploadHandler(context);
                      },
                      buttonColor: Colors.green,
                      iconData: Icons.upload_rounded,
                      iconSize: 30,
                      iconColor: Colors.white,
                      startDisabled: true,
                      label: AppLocalizations.of(context).translate("app_photos_file_upload_btnUpload"),
                     labelStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
