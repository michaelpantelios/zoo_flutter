import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_info.dart';
import 'package:zoo_flutter/apps/singleplayergames/singleplayer_game_thumb.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class SinglePlayerCategoryRow extends StatefulWidget {
  SinglePlayerCategoryRow({Key key, this.categoryName, this.data, this.myWidth, this.thumbClickHandler});

  final String categoryName;
  final List<SinglePlayerGameInfo> data;
  final double myWidth;
  final Function thumbClickHandler;

  SinglePlayerCategoryRowState createState() => SinglePlayerCategoryRowState();
}

class SinglePlayerCategoryRowState extends State<SinglePlayerCategoryRow>{
  SinglePlayerCategoryRowState();

  ScrollController _controller;
  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  double _buttonWidth = 40;

  List<SinglePlayerGameThumb> _gameThumbs = [];

  _onScrollLeft(){
    _controller.animateTo(_controller.offset - SinglePlayerGameThumb.myWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  _onScrollRight(){
    _controller.animateTo(_controller.offset + SinglePlayerGameThumb.myWidth,
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
    _btnRightKey.currentState.setDisabled((widget.data.length * SinglePlayerGameThumb.myWidth) + 2 * _buttonWidth <= widget.myWidth);
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    for (int i=0; i<widget.data.length; i++){
      _gameThumbs.add(SinglePlayerGameThumb(
        data: widget.data[i],
        onClickHandler: widget.thumbClickHandler,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.myWidth,
        height: SinglePlayerGameThumb.myHeight+ 50,
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
                height: SinglePlayerGameThumb.myHeight + 20,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ZButton(
                      minWidth: _buttonWidth,
                      key: _btnLeftKey,
                      iconData: Icons.arrow_back_ios,
                      iconColor: Colors.blue,
                      iconSize: 30,
                      clickHandler: _onScrollLeft,
                      startDisabled: true,
                    ) ,
                    Container(
                        width: widget.myWidth - 120,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _controller,
                          itemExtent: SinglePlayerGameThumb.myWidth,
                          scrollDirection: Axis.horizontal,
                          children: _gameThumbs,
                        )
                    ),
                   ZButton(
                    minWidth: _buttonWidth,
                    key: _btnRightKey,
                    iconData: Icons.arrow_forward_ios,
                    iconColor: Colors.blue,
                    iconSize: 30,
                    clickHandler: _onScrollRight,
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

