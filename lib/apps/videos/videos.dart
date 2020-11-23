import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:core';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/videos/video_thumb.dart';

class Videos extends StatefulWidget {
  Videos();

  VideosState createState() => VideosState();
}

class VideosState extends State<Videos>{
  VideosState();

  Size _appSize = DataMocker.apps["videos"].size;
  int videoRows = 4;
  int photoCols = 4;
  int currentVideosPage;
  int currentStartIndex;
  int totalPages;
  int pageSize;
  bool openVideoSelf = true;

  List<VideoThumbData> videosData;
  List<TableRow> videoRowsList;
  List<GlobalKey<VideoThumbState>> thumbKeys;
  GlobalKey<ZButtonState> nextPageButtonKey;
  GlobalKey<ZButtonState> previousPageButtonKey;

  playVideo(){}
  editVideo(){}
  deleteVideo(){}
  uploadFromFile(){}

  onPreviousPage(){
    print("goBack");
    if (currentVideosPage == 1) return;
    setState(() {
      currentVideosPage--;
      currentStartIndex-=pageSize;
      updateVideos(null);
    });
  }

  onNextPage(){
    print("goNext");
    if (currentVideosPage == totalPages) return;
    setState(() {
      currentVideosPage++;
      currentStartIndex+=pageSize;
      print("currentPhotosPage = "+currentVideosPage.toString());
      print("currentStartIndex = "+currentStartIndex.toString());
      updateVideos(null);
    });
  }

  updateVideos(_){
    if (videosData.length == 0) return;
    for (int i=0; i < pageSize; i++){
      print("i = "+i.toString());
      print("i + currentStartIndex = "+(i + currentStartIndex).toString());
      if (i+currentStartIndex < videosData.length)
        thumbKeys[i].currentState.update(videosData[i+currentStartIndex]);
      else thumbKeys[i].currentState.clear();
    }
    updatePager();
  }

  updatePager(){
    previousPageButtonKey.currentState.setDisabled(currentVideosPage == 1);
    nextPageButtonKey.currentState.setDisabled(currentVideosPage == totalPages);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(updateVideos);
    nextPageButtonKey = new GlobalKey<ZButtonState>();
    previousPageButtonKey = new GlobalKey<ZButtonState>();

    videosData = new List<VideoThumbData>();
    for (int i=0; i<38; i++){
      videosData.add(new VideoThumbData(id : i.toString(), videoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png"));
    }
    pageSize = videoRows * photoCols;
    currentStartIndex = 0;
    totalPages = (38 / pageSize).ceil();
    currentVideosPage = 1;

    thumbKeys = new List<GlobalKey<VideoThumbState>>();
    videoRowsList = new List<TableRow>();
    for (int i=0; i<videoRows; i++){
      List<TableCell> cells = new List<TableCell>();
      for (int j=0; j<photoCols; j++) {
        GlobalKey<VideoThumbState> theKey = new GlobalKey<VideoThumbState>();
        cells.add(new TableCell(child: VideoThumb(key : theKey)));
        thumbKeys.add(theKey);
      }
      TableRow row = new TableRow(children: cells);
      videoRowsList.add(row);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String pagingText = AppLocalizations.of(context).translate("app_videos_lblPage")
        + " "
        + currentVideosPage.toString()
        + " "
        + AppLocalizations.of(context).translate("app_videos_lblFrom")
        + " "
        + totalPages.toString();

    return Container(
      color: Theme.of(context).canvasColor,
      height:_appSize.height-4,
      width: _appSize.width - 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                  width: _appSize.width - 170,
                  // height: _appSize.height,
                  child: videosData.length == 0 ?
                  Center(
                      child: Text(AppLocalizations.of(context).translate("app_videos_noVideos"),
                          style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                  )
                      : Table(
                    children: videoRowsList,
                  )
              ),
              Expanded(child: Container()),
              Container(
                width: _appSize.width - 170,
                height: 35,
                child: Row(
                  children: [
                    Container(
                      width: 220,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        onChanged: (value){ setState(() {
                          openVideoSelf = value;
                        }); },
                        value: openVideoSelf,
                        selected: openVideoSelf,
                        title: Text(AppLocalizations.of(context).translate("app_videos_chkOpenSelf"),
                          style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      )
                    ),
                    Expanded(child: Container()),
                    Container(
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
          ),
          SizedBox(width:5),
          Container(
            width: 150,
            child: Column(
              children: [
                ZButton(
                  label : AppLocalizations.of(context).translate("app_videos_btnPlay"),
                  clickHandler: playVideo,
                  buttonColor: Colors.white,
                  iconData: Icons.play_circle_outline,
                  iconColor: Colors.green,
                  iconSize: 25,
                ),
                SizedBox(height: 10),
                ZButton(
                  label : AppLocalizations.of(context).translate("app_videos_btnEdit"),
                  clickHandler: editVideo,
                  buttonColor: Colors.white,
                  iconData: Icons.edit_outlined,
                  iconColor: Colors.orange,
                  iconSize: 25,
                ),
                SizedBox(height: 10),
                ZButton(
                  label : AppLocalizations.of(context).translate("app_videos_btnDelete"),
                  clickHandler: deleteVideo,
                  buttonColor: Colors.white,
                  iconData: Icons.delete,
                  iconColor: Colors.red,
                  iconSize: 25,
                ),
                Expanded(child: Container()),
                ZButton(
                  label : AppLocalizations.of(context).translate("app_videos_btnUpload"),
                  clickHandler: uploadFromFile,
                  buttonColor: Colors.white,
                  iconData: Icons.file_upload,
                  iconColor: Colors.green,
                  iconSize: 25,
                ),
                SizedBox(height:4)
              ],
            )
          )
        ],
      ),
    );

  }
}