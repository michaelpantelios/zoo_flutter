import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ZBulletsPager extends StatefulWidget{
  ZBulletsPager({Key key, this.pagesNumber, this.onBulletClickHandler}) : super(key: key);

  final int pagesNumber;
  final Function onBulletClickHandler;

  ZBulletsPagerState createState() => ZBulletsPagerState(key: key);
}

class ZBulletsPagerState extends State<ZBulletsPager>{
  ZBulletsPagerState({Key key});

  int currentPage = 1;
  List<Widget> bullets;
  double bulletSize = 16;

  @override
  void initState() {
    bullets = new List<Widget>();

    for(int i=0; i<widget.pagesNumber; i++){
      bullets.add(
          _getBulletItem(i, i == (currentPage-1))
      );
    }
    super.initState();
  }

  _getBulletItem(int index, bool active){
    return GestureDetector(
      onTap: (){
        setCurrentPage(index);
        widget.onBulletClickHandler(index);
      },
      child: Padding(
          padding: EdgeInsets.all(2),
          child: Icon( Icons.circle, color: active ? Colors.indigo : Colors.orange[700], size: bulletSize)
      ),
    );
  }


  setCurrentPage(int cur){
    setState(() {
      currentPage = cur;
      bullets.clear();
      for(int i=0; i<widget.pagesNumber; i++){
        bullets.add(
            _getBulletItem(i, i == (currentPage-1))
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.pagesNumber == 0) ? Container() :
        Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical:5),
              child:   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bullets
              )
          )
        );
  }
}

