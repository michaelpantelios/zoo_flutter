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
  GlobalKey<ZButtonState> btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> btnRightKey = GlobalKey<ZButtonState>();

  int pageSize;
  int scrollFactor = 1;
  bool showArrows = false;

  onScrollLeft(){
    _controller.animateTo(_controller.offset - scrollFactor * SinglePlayerGameThumb.myWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  onScrollRight(){
    btnLeftKey.currentState.isHidden = false;
    _controller.animateTo(_controller.offset + scrollFactor * SinglePlayerGameThumb.myWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    pageSize = (widget.myWidth / SinglePlayerGameThumb.myWidth).floor();
    showArrows = widget.data.length > pageSize;

    scrollFactor = pageSize;
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        btnRightKey.currentState.isDisabled = true;
      });
    }

    if (_controller.offset < _controller.position.maxScrollExtent && _controller.offset > _controller.position.minScrollExtent)
      setState(() {
        btnRightKey.currentState.isDisabled = false;
        btnLeftKey.currentState.isDisabled = false;
      });

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        btnLeftKey.currentState.isDisabled = true;
      });
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
              padding: EdgeInsets.only(left: 10, top:5, bottom: 5, right: 5),
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
                    showArrows ? ZButton(
                      key: btnLeftKey,
                      iconData: Icons.arrow_back_ios,
                      iconColor: Colors.blue,
                      iconSize: 40,
                      clickHandler: onScrollLeft,
                      startDisabled: true,
                    ) : SizedBox(width: 40),
                    Container(
                        width: widget.myWidth - 120,
                        child: ListView.builder(
                          controller: _controller,
                          itemExtent: SinglePlayerGameThumb.myWidth,
                          itemCount:widget.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index){
                            return SinglePlayerGameThumb(
                              data: widget.data[index],
                              onClickHandler: widget.thumbClickHandler,
                            );
                          },
                        )
                    ),
                    showArrows ? ZButton(
                        key: btnRightKey,
                        iconData: Icons.arrow_forward_ios,
                        iconColor: Colors.blue,
                        iconSize: 40,
                        clickHandler: onScrollRight
                    ): SizedBox(width: 40),
                  ],
                )
            )
          ],
        )
    );
  }


}

