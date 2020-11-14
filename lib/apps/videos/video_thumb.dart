import 'package:flutter/material.dart';

class VideoThumbData{
  String id;
  String videoUrl;

  VideoThumbData({@required this.id, this.videoUrl});
}

class VideoThumb extends StatefulWidget{
  VideoThumb({Key key}) : super(key: key);

  VideoThumbState createState() => VideoThumbState(key: key);
}

class VideoThumbState extends State<VideoThumb>{
  VideoThumbState({Key key});

  VideoThumbData _data;
  bool mouseOver = false;
  Size size = new Size(100, 110);
  String duration = "00:00:00";

  update(VideoThumbData data){
    setState(() {
      _data = data;
    });
  }

  clear(){
    print("clear");
    setState(() {
      _data = null;
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return MouseRegion(
     onEnter: (_){
       setState(() {
         mouseOver = true;
       });
     },
     onExit: (_){
       setState(() {
         mouseOver = false;
       });
     },
     child: _data == null ? Container() : Container(
       margin: EdgeInsets.all(2),
       width: size.width,
       height: size.height,
       decoration: BoxDecoration(
         color: Colors.white,
         border: mouseOver ? Border.all(color: Colors.blue, width: 2) : Border.all(color: Colors.grey[500], width: 1) ,
       ),
       child: Stack(
         children: [
           Container(color: Colors.orange),
           Column(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               Container(
                   decoration: BoxDecoration(
                       color: new Color.fromRGBO(10, 10, 10, 0.8) // Specifies the background color and the opacity
                   ),
                   child: Center(
                     child: Text(duration, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                   )
               )
             ],
           )
         ],
       )

     )
   );
  }
}