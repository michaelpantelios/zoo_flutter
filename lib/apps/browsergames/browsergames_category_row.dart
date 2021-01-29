import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_thumb.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class BrowserGamesCategoryRow extends StatefulWidget {
  BrowserGamesCategoryRow({Key key, this.categoryName, this.data, this.myWidth, this.thumbClickHandler}) : super(key: key);

  final String categoryName;
  final List<BrowserGameInfo> data;
  final double myWidth;
  final Function thumbClickHandler;

  BrowserGamesCategoryRowState createState() => BrowserGamesCategoryRowState(key: key);
}

class BrowserGamesCategoryRowState extends State<BrowserGamesCategoryRow> {
  BrowserGamesCategoryRowState({Key key});

  ScrollController _controller;
  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  double _buttonWidth = 40;

  List<BrowserGameThumb> _gameThumbs = [];

  onScrollLeft(){
    _controller.animateTo(_controller.offset - BrowserGameThumb.myWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  onScrollRight(){
    _btnLeftKey.currentState.isHidden = false;
    _controller.animateTo(_controller.offset + BrowserGameThumb.myWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _btnRightKey.currentState.isDisabled = true;
      });
    }

    if (_controller.offset < _controller.position.maxScrollExtent && _controller.offset > _controller.position.minScrollExtent)
      setState(() {
        _btnRightKey.currentState.isDisabled = false;
        _btnLeftKey.currentState.isDisabled = false;
      });

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _btnLeftKey.currentState.isDisabled = true;
      });
    }
  }

  postFrameCallback(_){
    _btnRightKey.currentState.setDisabled((widget.data.length *  BrowserGameThumb.myWidth) + 2 * _buttonWidth <= widget.myWidth);
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    for (int i=0; i<widget.data.length; i++){
      _gameThumbs.add(BrowserGameThumb(
        key: new GlobalKey(),
        data: widget.data[i],
        onClickHandler: widget.thumbClickHandler,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    print("category row BUILD");
    return Container(
        width: widget.myWidth,
        height: BrowserGameThumb.myHeight+ 50,
        child: Column(
          children: [
            Container(
              width: widget.myWidth,
              height: 30,
              color: Theme.of(context).secondaryHeaderColor,
              padding: EdgeInsets.only(left: 5, top:5, bottom: 5, right: 5),
              child: Text(widget.categoryName + " ("+ widget.data.length.toString()+")",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
                width: widget.myWidth,
                height: BrowserGameThumb.myHeight + 20,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   ZButton(
                      minWidth: _buttonWidth,
                      key: _btnLeftKey,
                      iconData: Icons.arrow_back_ios,
                      iconColor: Colors.blue,
                      iconSize: 40,
                      clickHandler: onScrollLeft,
                      startDisabled: true,
                    ),
                    Container(
                        width: widget.myWidth - 120,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _controller,
                          itemExtent: BrowserGameThumb.myWidth,
                          scrollDirection: Axis.horizontal,
                          children: _gameThumbs
                        )
                    ),
                    ZButton(
                      minWidth: _buttonWidth,
                      key: _btnRightKey,
                      iconData: Icons.arrow_forward_ios,
                      iconColor: Colors.blue,
                      iconSize: 40,
                      clickHandler: onScrollRight,
                      startDisabled: true,
                    ),
                  ],
                )
            )
          ],
        )
    );
  }


}