import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ProfileVideoModel{
  final String url;

  ProfileVideoModel({this.url});
}

class ProfileVideos extends StatefulWidget{
  ProfileVideos({Key key, this.myWidth, this.username, this.isMe}) : super(key: key);

  final double myWidth;
  final String username;
  final bool isMe;

  ProfileVideosState createState() => ProfileVideosState(key: key);
}

class ProfileVideosState extends State<ProfileVideos>{
  ProfileVideosState({Key key});

  List<ProfileVideoModel> videosData;
  bool dataReady;

  @override
  void initState() {
    dataReady = false;
    super.initState();
  }

  updateData(List<ProfileVideoModel> videosList){
    setState(() {
      dataReady = true;
      videosData = videosList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (!dataReady) ? Container() : Column(
      children: [
        Container(
            width: widget.myWidth,
            color: Colors.orange[700],
            padding: EdgeInsets.only(left: 10, top:5, bottom: 5, right: 5),
            child: Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblVideos", [videosData.length.toString()]),
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            height: 30),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: widget.myWidth,
            //height: 200,
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color:Colors.orange[700], width: 1),
            ),
            child: (videosData.length == 0) ?
            Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                    child: Text(
                        widget.isMe ? AppLocalizations.of(context).translate("app_profile_youHaveNoVideos")
                            : AppLocalizations.of(context).translateWithArgs("app_profile_noVideos", [widget.username]),
                        style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)
                    )
                )
            )
                :Container())
      ],
    );
  }
}