import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/gifts/models/gift_category_model.dart';

class GiftCategoryItem extends StatefulWidget{
  GiftCategoryItem({Key key, this.onSelected, this.data, this.isSelected }) : super(key : key);

  final bool isSelected;
  final Function onSelected;
  final GiftCategoryModel data;

  static double myHeight = 30;

  GiftCategoryItemState createState() => GiftCategoryItemState(key : key);
}

class GiftCategoryItemState extends State<GiftCategoryItem>{
  GiftCategoryItemState({Key key});

  Color _idleColor = Colors.white;
  Color _overColor = Color(0xffF7F7F7);
  Color _selectedColor = Color(0xffF7F7F7);

  bool _selected = false;

  Color _currentColor;

  setSelected(int selectedId){
    print("unselect, selected id = "+selectedId.toString());
    setState(() {
      _selected = widget.data.id == selectedId;
      _currentColor = _selected ? _selectedColor : _idleColor;
    });
  }

  _setSelected(){
    setState(() {
      if (!_selected){
        _selected = true;
        _currentColor = _selectedColor;
        widget.onSelected(widget.data.id);
      }
    });
  }

  @override
  void initState() {
    _selected = widget.isSelected;
    _currentColor = _selected ? _selectedColor : _idleColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) {
          setState(() {
           _currentColor = _overColor;
          });
        },
        onExit: (_) {
          setState(() {
            _currentColor = _selected ? _selectedColor : _idleColor;
          });
        },
        child: GestureDetector(
          onTap: (){
            _setSelected();
          },
          child: Container(
            padding: EdgeInsets.only(left: 20),
            height: GiftCategoryItem.myHeight,
            width: double.infinity,
            color: _currentColor,
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context).translate("app_gifts_"+widget.data.code), style: TextStyle(color: _selected ? Theme.of(context).primaryColor : Color(0xff9598A4), fontSize: 20, fontWeight: FontWeight.normal))
          )
        )
    );
  }



}