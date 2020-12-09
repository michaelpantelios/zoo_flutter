import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/gifts/user_gift_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ProfileGiftThumb extends StatefulWidget {
  ProfileGiftThumb({Key key, @required this.giftInfo}) : super(key: key);

  static Size size = Size(100, 100);

  final UserGiftInfo giftInfo;

  ProfileGiftThumbState createState() => ProfileGiftThumbState();
}

class ProfileGiftThumbState extends State<ProfileGiftThumb>{
  ProfileGiftThumbState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        Container(
            margin: EdgeInsets.all(5),
            width: ProfileGiftThumb.size.width,
            height: ProfileGiftThumb.size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[500], width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child:
                    Image.network(
                        widget.giftInfo.giftURL,
                        fit: BoxFit.fitWidth)
                ),
                // (widget.giftInfo.fromUser == null) ?
                // Container(
                //   width: ProfileGiftThumb.size.width,
                //   child: Text(
                //     AppLocalizations.of(context).translate("app_profile_privateGift"),
                //     style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)
                //   )
                // ) :
                // GestureDetector(
                //   onTap: (){
                //     print("open Profile");
                //   },
                //   child: Container(
                //     width: ProfileGiftThumb.size.width,
                //       padding: EdgeInsets.only( top: 10),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Icon( Icons.face, color: widget.giftInfo.fromUser.sex == 1 ? Colors.blue : Colors.pink, size: 15),
                //           Padding(
                //               padding: EdgeInsets.symmetric(horizontal: 3),
                //               child: Text(widget.giftInfo.fromUser.username, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left)
                //           ),
                //           widget.giftInfo.fromUser.photoUrl == null ? Container() : Icon(Icons.camera_alt, color: Colors.orange, size: 10)
                //         ],
                //       )
                //   ),
                // )
              ],
            )
        );
  }
}
