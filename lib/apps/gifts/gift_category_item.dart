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
  Color _overColor = Colors.cyan[200];
  Color _selectedColor = Colors.cyan;

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
            height: GiftCategoryItem.myHeight,
            width: double.infinity,
            color: _currentColor,
            child: Text(AppLocalizations.of(context).translate("app_gifts_"+widget.data.code), style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal))
          )
        )
    );
  }



}