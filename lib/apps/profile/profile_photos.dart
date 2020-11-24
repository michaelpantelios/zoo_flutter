import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/profile/profile_photo_thumb.dart';
import 'package:zoo_flutter/widgets/bullets_pager.dart';

class ProfilePhotos extends StatefulWidget{
  ProfilePhotos({Key key, this.myWidth, this.username, this.isMe}) : super(key: key);

  final double myWidth;
  final String username;
  final bool isMe;

  ProfilePhotosState createState() => ProfilePhotosState(key: key);
}

class ProfilePhotosState extends State<ProfilePhotos>{
  ProfilePhotosState({Key key});

  List<ProfilePhotoThumbData> photosData;
  List<TableRow> photoRowsList;
  List<GlobalKey<ProfilePhotoThumbState>> thumbKeys;
  GlobalKey<ZButtonState> nextPageButtonKey;
  GlobalKey<ZButtonState> previousPageButtonKey;
  GlobalKey<BulletsPagerState> bulletsPagerKey;

  int photoRows = 2;
  int photoCols = 3;
  int currentPhotosPage;
  int currentStartIndex;
  int totalPages;
  int pageSize;

  onPhotoClicked(String url){
    print("clicked on "+url);
  }

  onBulletPagerClicked(int index){
    setState(() {
      currentPhotosPage = index+1;
      currentStartIndex = index * pageSize;
      updatePhotos();
    });
  }

  onPreviousPage(){
    print("goBack");
    if (currentPhotosPage == 1) return;
    setState(() {
      currentPhotosPage--;
      currentStartIndex -= pageSize;
      updatePhotos();
    });
  }

  onNextPage(){
    print("goNext");
    if (currentPhotosPage == totalPages) return;
    setState(() {
      currentPhotosPage++;
      currentStartIndex += pageSize;
      updatePhotos();
    });
  }

  updatePhotos(){
    for (int i=0; i < pageSize; i++){
      if (i+currentStartIndex < photosData.length)
        thumbKeys[i].currentState.update(photosData[i+currentStartIndex]);
      else thumbKeys[i].currentState.clear();
    }
    updatePageControls();
  }

  updatePageControls(){
    previousPageButtonKey.currentState.setDisabled(currentPhotosPage == 1);
    nextPageButtonKey.currentState.setDisabled(currentPhotosPage == totalPages);
    bulletsPagerKey.currentState.setCurrentPage(currentPhotosPage);
  }

  @override
  void initState() {
    super.initState();

    nextPageButtonKey = new GlobalKey<ZButtonState>();
    previousPageButtonKey = new GlobalKey<ZButtonState>();
    bulletsPagerKey = new GlobalKey<BulletsPagerState>();

    pageSize = photoRows * photoCols;
    currentStartIndex = 0;
    currentPhotosPage = 1;

    // photosData = new List<ProfilePhotoThumbData>();
    photosData = new List();

    thumbKeys = new List<GlobalKey<ProfilePhotoThumbState>>();
    photoRowsList = new List<TableRow>();
    for (int i=0; i<photoRows; i++){
      List<TableCell> cells = new List<TableCell>();
      for (int j=0; j<photoCols; j++) {
        GlobalKey<ProfilePhotoThumbState> theKey = new GlobalKey<ProfilePhotoThumbState>();
        cells.add(new TableCell(child: ProfilePhotoThumb(key : theKey, onClickHandler: onPhotoClicked)));
        thumbKeys.add(theKey);
      }
      TableRow row = new TableRow(children: cells);
      photoRowsList.add(row);
    }

  }
  
  updateData(List<ProfilePhotoThumbData> photosList){
    setState(() {
      photosData += photosList;

      if (photosData.length == 0 ) {
        nextPageButtonKey.currentState.setHidden(true);
        previousPageButtonKey.currentState.setHidden(true);
        return;
      }

      totalPages = (photosData.length / pageSize).ceil();
      bulletsPagerKey.currentState.initPager(totalPages);

      updatePhotos();
    });
  }

  getEmptyPhotosMessage(){
    return (photosData.length == 0) ?
    Padding(
        padding: EdgeInsets.all(10),
        child: Center(
            child: Text(
                widget.isMe ? AppLocalizations.of(context).translate("app_profile_youHaveNoPhotos")
                    : AppLocalizations.of(context).translateWithArgs("app_profile_noPhotos", [widget.username]),
                style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)
            )
        )
    )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Container(
           width: widget.myWidth,
           color: Colors.orange[700],
           padding: EdgeInsets.only(left: 10, top:5, bottom: 5, right: 5),
           child: Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblPhotos", [photosData.length.toString()]),
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
           child: Stack(
             children: [
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Row (
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             ZButton(
                               key: previousPageButtonKey,
                               clickHandler: onPreviousPage,
                               iconData: Icons.arrow_back_ios,
                               iconColor: Colors.blue,
                               iconSize: 30,
                             ),
                             Expanded(
                               child: Table(
                                   children: photoRowsList,
                                 ),
                             ),
                             ZButton(
                               key: nextPageButtonKey,
                               clickHandler: onNextPage,
                               iconData: Icons.arrow_forward_ios,
                               iconColor: Colors.blue,
                               iconSize: 30,
                             )
                           ]
                       ),
                        BulletsPager(key: bulletsPagerKey, onBulletClickHandler: onBulletPagerClicked)
                     ]
                 ),
                getEmptyPhotosMessage()
             ],
           )
       )
     ],
   );
  }
}