import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/gifts/models/gift_model.dart';

class GiftItem extends StatefulWidget{
  GiftItem({Key key, this.onSelected}) : super(key : key);

  final Function onSelected;

  static double myWidth = 115;
  static double myHeight = 115;

  GiftItemState createState() => GiftItemState(key : key);
}

class GiftItemState extends State<GiftItem>{
  GiftItemState({Key key});

  Color _idleBorderColor = Colors.black;
  Color _overBorderColor = Colors.blue;
  Color _selectedBorderColor = Colors.green[600];
  bool _selected = false;
  Color _currentColor;
  GiftModel _data;

  update(GiftModel data){
    setState(() {
      _data = data;
      _selected = false;
      _currentColor = _idleBorderColor;
    });
  }

  clear(){
    setState(() {
      _data = null;
    });
  }

  setSelected(int selectedId){
    print("unselect, selected id = "+selectedId.toString());
    setState(() {
      _selected = _data.id == selectedId;
      _currentColor = _selected ? _selectedBorderColor : _idleBorderColor;
    });
  }

  _setSelected(){
    if (!_selected){
      _selected = true;
      _currentColor = _selectedBorderColor;
      widget.onSelected(_data);
    }
  }

  @override
  void initState(){
    _currentColor = _idleBorderColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _data == null ? SizedBox(width: GiftItem.myWidth, height: GiftItem.myHeight) :
      MouseRegion(
      onEnter: (_) {
        setState(() {
          _currentColor = _overBorderColor;
        });
      },
      onExit: (_) {
        setState(() {
          _currentColor = _selected ? _selectedBorderColor : _idleBorderColor;
        });
      },
      child: GestureDetector(
        onTap: (){
          _setSelected();
        },
        child: Tooltip(
          message: _data.name,
            textStyle: TextStyle(
                fontSize: 14
            ),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                new BoxShadow(color: Color(0xaa000000), offset: new Offset(2.0, 2.0), blurRadius: 6, spreadRadius: 3),
              ],
            ),
          child: Container(
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: _currentColor,
                    width: 1,
                  )
              ),
              child: Center(
                child: Image.network(_data.url, width: GiftItem.myWidth, height: GiftItem.myHeight)
              )
          )
        )
      )
    );
  }


}
