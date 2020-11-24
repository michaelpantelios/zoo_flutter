import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/profile/profile_gift_thumb.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ProfileGifts extends StatefulWidget{
  ProfileGifts({Key key, this.myWidth, this.username, this.isMe}): super(key: key);

  final double myWidth;
  final String username;
  final bool isMe;

  ProfileGiftsState createState() => ProfileGiftsState(key: key);
}

class ProfileGiftsState extends State<ProfileGifts>{
  ProfileGiftsState({Key key});

  List<ProfileGiftData> giftsData;
  bool dataReady;

  @override
  void initState() {
    dataReady = false;
    super.initState();
  }

  updateData(List<ProfileGiftData> giftsList){
    setState(() {
      dataReady = true;
      giftsData = giftsList;
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
            child: Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblGifts", [giftsData.length.toString()]),
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            height: 30),
        Container(
            //margin: EdgeInsets.only(bottom: 10),
            width: widget.myWidth,
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color:Colors.orange[700], width: 1),
            ),
            child: (giftsData.length == 0) ?
            Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                    child: Text(
                        widget.isMe ? AppLocalizations.of(context).translate("app_profile_youHaveNoGifts")
                            : AppLocalizations.of(context).translateWithArgs("app_profile_noGifts", [widget.username]),
                        style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)
                    )
                )
            )
                :Container())
      ],
    );
  }
}