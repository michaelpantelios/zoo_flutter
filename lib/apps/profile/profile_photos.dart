import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/profile/profile_photo_thumb.dart';
import 'package:zoo_flutter/widgets/z_record_set.dart';

class ProfilePhotos extends StatefulWidget{
  ProfilePhotos({Key key, this.photosData, this.myWidth, this.username, this.isMe}) : super(key: key);

  final List photosData;
  final double myWidth;
  final String username;
  final bool isMe;

  ProfilePhotosState createState() => ProfilePhotosState(key: key);
}

class ProfilePhotosState extends State<ProfilePhotos>{
  ProfilePhotosState({Key key});

  List<TableRow> photoRowsList;
  List<GlobalKey<ProfilePhotoThumbState>> thumbKeys;

  int photoRows = 2;
  int photoCols = 3;

  onPhotoClicked(String url){
    print("clicked on "+url);
  }

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Container(
           width: widget.myWidth,
           color: Colors.orange[700],
           padding: EdgeInsets.only(left: 10, top:5, bottom: 5, right: 5),
           child: Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblPhotos", [widget.photosData.length.toString()]),
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
             data: widget.photosData,
             colsNum: photoCols,
             rowsNum: photoRows,
             rowsList: photoRowsList,
             thumbKeys: thumbKeys,
             zeroItemsMessage: widget.isMe ? AppLocalizations.of(context).translate("app_profile_youHaveNoPhotos")
                 : AppLocalizations.of(context).translateWithArgs("app_profile_noPhotos", [widget.username])
           )
       )
     ],
   );
  }
}