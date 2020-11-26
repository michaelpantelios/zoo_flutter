import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/profile/profile_video_thumb.dart';
import 'package:zoo_flutter/widgets/z_bullets_pager.dart';
import 'package:zoo_flutter/widgets/z_record_set.dart';

class ProfileVideos extends StatefulWidget{
  ProfileVideos({Key key, this.videosData, this.myWidth, this.username, this.isMe}) : super(key: key);

  final List videosData;
  final double myWidth;
  final String username;
  final bool isMe;

  ProfileVideosState createState() => ProfileVideosState(key: key);
}

class ProfileVideosState extends State<ProfileVideos>{
  ProfileVideosState({Key key});

  List<TableRow> videoRowsList;
  List<GlobalKey<ProfileVideoThumbState>> thumbKeys;
  GlobalKey<ZButtonState> nextPageButtonKey;
  GlobalKey<ZButtonState> previousPageButtonKey;
  GlobalKey<ZBulletsPagerState> bulletsPagerKey;
  GlobalKey<ZRecordSetState> recordSetKey;

  int videoRows = 2;
  int videoCols = 3;
  int currentVideosPage;
  int currentStartIndex;
  int totalPages;
  int pageSize;

  onVideoClicked(String url){
    print("clicked on "+url);
  }

  @override
  void initState() {
    super.initState();

    pageSize = videoRows * videoCols;
    currentStartIndex = 0;
    currentVideosPage = 1;

    thumbKeys = new List<GlobalKey<ProfileVideoThumbState>>();
    videoRowsList = new List<TableRow>();
    for (int i=0; i<videoRows; i++){
      List<TableCell> cells = new List<TableCell>();
      for (int j=0; j<videoCols; j++) {
        GlobalKey<ProfileVideoThumbState> theKey = new GlobalKey<ProfileVideoThumbState>();
        cells.add(new TableCell(child: ProfileVideoThumb(key : theKey, onClickHandler: onVideoClicked)));
        thumbKeys.add(theKey);
      }
      TableRow row = new TableRow(children: cells);
      videoRowsList.add(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: widget.myWidth,
            color: Colors.orange[700],
            padding: EdgeInsets.only(left: 10, top:5, bottom: 5, right: 5),
            child: Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblVideos", [widget.videosData.length.toString()]),
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            height: 30),
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(bottom: 10),
            //  width: widget.myWidth,
            // height: 200,
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color:Colors.orange[700], width: 1),
            ),
            child:
            ZRecordSet(
                data: widget.videosData,
                colsNum: videoCols,
                rowsNum: videoRows,
                rowsList: videoRowsList,
                thumbKeys: thumbKeys,
                zeroItemsMessage: widget.isMe ? AppLocalizations.of(context).translate("app_profile_youHaveNoVideos")
                    : AppLocalizations.of(context).translateWithArgs("app_profile_noVideos", [widget.username])
            )
        )
      ],
    );
  }
}