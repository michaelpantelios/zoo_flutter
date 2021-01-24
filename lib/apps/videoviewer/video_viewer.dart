import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/video/user_video_model.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class VideoViewer extends StatefulWidget {
  VideoViewer({this.size, this.data, this.setBusy, this.onClose});

  final Size size;
  final dynamic data;
  final Function(bool value) setBusy;
  final Function onClose;

  VideoViewerState createState() => VideoViewerState();
}

class VideoViewerState extends State<VideoViewer>{
  VideoViewerState();



  // String url = "/videos/" + qual + "/" + videoData.id

  @override
  void initState(){
    super.initState();

    print("lets play video  :");
    UserVideoModel videoInfo = widget.data["videoInfo"];
    print(videoInfo.id.toString());

  }

  @override
  Widget build(BuildContext context) {
   return Container(

   );
  }


}