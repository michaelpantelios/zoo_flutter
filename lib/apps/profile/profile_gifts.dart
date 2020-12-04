import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_bullets_pager.dart';
import 'package:zoo_flutter/widgets/z_record_set.dart';
import 'package:zoo_flutter/apps/profile/profile_gift_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_photo_thumb.dart';

class ProfileGifts extends StatefulWidget {
  ProfileGifts({Key key, this.giftsData, this.myWidth, this.username, this.isMe}) : super(key: key);

  final List giftsData;
  final double myWidth;
  final String username;
  final bool isMe;

  ProfileGiftsState createState() => ProfileGiftsState(key: key);
}

class ProfileGiftsState extends State<ProfileGifts>{
  ProfileGiftsState({Key key});

  List<TableRow> giftRowsList;
  List<GlobalKey<ProfileGiftThumbState>> thumbKeys;
  GlobalKey<ZButtonState> nextPageButtonKey;
  GlobalKey<ZButtonState> previousPageButtonKey;
  GlobalKey<ZBulletsPagerState> bulletsPagerKey;
  GlobalKey<ZRecordSetState> recordSetKey;

  int giftRows = 2;
  int giftCols = 3;
  int currentPage;
  int currentStartIndex;
  int totalPages;
  int pageSize;

  @override
  void initState() {
    super.initState();

    pageSize = giftRows * giftCols;
    currentStartIndex = 0;
    currentPage = 1;

    thumbKeys = new List<GlobalKey<ProfileGiftThumbState>>();
    giftRowsList = new List<TableRow>();
    for (int i=0; i<giftRows; i++){
      List<TableCell> cells = new List<TableCell>();
      for(int j=0; j<giftCols; j++){
        GlobalKey<ProfileGiftThumbState> theKey = new GlobalKey<ProfileGiftThumbState>();
        cells.add(new TableCell(child: ProfileGiftThumb(key : theKey)));
        thumbKeys.add(theKey);
      }
      TableRow row = new TableRow(children:  cells);
      giftRowsList.add(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.myWidth,
          height: 30,
          color: Colors.orange[700],
          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
          child: Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblGifts", [widget.giftsData.length.toString()]),
          style: TextStyle(color:Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.orangeAccent[50],
            border: Border.all(color: Colors.orange[700], width: 1),
          ),
          child:
            ZRecordSet(
              data: widget.giftsData,
              colsNum: giftCols,
              rowsNum: giftRows,
              rowsList: giftRowsList,
              thumbKeys: thumbKeys,
              zeroItemsMessage: widget.isMe ? AppLocalizations.of(context).translate("app_profile_youHaveNoGifts")
                  : AppLocalizations.of(context).translateWithArgs("app_profile_noGifts", [widget.username])
            )
        )
      ],
    );
  }
}