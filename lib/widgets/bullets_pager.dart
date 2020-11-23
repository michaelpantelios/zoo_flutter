import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class BulletsPager extends StatefulWidget{
  BulletsPager({Key key, this.onBulletClickHandler}) : super(key: key);

  final Function onBulletClickHandler;

  BulletsPagerState createState() => BulletsPagerState(key: key);
}

class BulletsPagerState extends State<BulletsPager>{
  BulletsPagerState({Key key});

  int pagesNum = 0;
  int currentPage = 1;
  List<Widget> bullets;
  double bulletSize = 16;

  @override
  void initState() {
    bullets = new List<Widget>();
    super.initState();
  }

  getBulletItem(int index, bool active){
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

  initPager(int pagesNumber){
    setState(() {
      pagesNum = pagesNumber;
      for(int i=0; i<pagesNum; i++){
        bullets.add(
            getBulletItem(i, i == (currentPage-1))
        );
      }
    });
  }

  setCurrentPage(int cur){
    setState(() {
      currentPage = cur;
      bullets.clear();
      for(int i=0; i<pagesNum; i++){
        bullets.add(
            getBulletItem(i, i == (currentPage-1))
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (pagesNum == 0) ? Container() :
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

