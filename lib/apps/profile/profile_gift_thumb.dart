import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/interfaces/record_set_thumb_interface.dart';

class ProfileGiftThumbData {
  final String path;
  final int senderId;
  final String username;
  final String photoUrl;
  final int sex;

  ProfileGiftThumbData({this.path, @required this.senderId, @required this.sex, @required this.username, this.photoUrl});
}

class ProfileGiftThumb extends StatefulWidget {
  ProfileGiftThumb({Key key}) : super(key: key);

  ProfileGiftThumbState createState() => ProfileGiftThumbState(key: key);
}

class ProfileGiftThumbState extends State<ProfileGiftThumb>
    implements RecordSetThumbInterface {
  ProfileGiftThumbState({Key key});

  ProfileGiftThumbData _data;
  Size size = new Size(90, 130);
  bool isEmpty = false;
  bool test = true;

  @override
  update(Object data) {
    setState(() {
      isEmpty = false;
      _data = data;
    });
  }

  @override
  clear() {
    print("clear");
    setState(() {
      isEmpty = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
     MouseRegion(
      child:
        (_data == null)
            ? Container()
            : isEmpty
                ? Container(
                    margin: EdgeInsets.all(5),
                    width: size.width,
                    height: size.height,
                    child: Center(
                        child:
                            SizedBox(width: size.width, height: size.height)))
                 :
            Container(
              margin: EdgeInsets.all(5),
              width: size.width,
              height: size.height,
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
                      Image.asset(
                          _data.path,
                          fit: BoxFit.fitWidth)
                  ),
                  GestureDetector(
                    onTap: (){
                      print("open Profile");
                    },
                    child: Container(
                      width: size.width,
                        padding: EdgeInsets.only( top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon( Icons.face, color: _data.sex == 0 ? Colors.blue : Colors.pink, size: 15),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                child: Text(_data.username, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left)
                            ),
                            _data.photoUrl == null ? Container() : Icon(Icons.camera_alt, color: Colors.orange, size: 10)
                          ],
                        )
                    ),
                  )
                ],
              )
          )
    );
  }
}
