import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/gifts/models/gift_category_model.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/gifts/gift_category_item.dart';
import 'package:zoo_flutter/apps/gifts/gift_item.dart';
import 'package:zoo_flutter/apps/gifts/models/gift_model.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';

class Gifts extends StatefulWidget{
   Gifts({@required this.username, @required this.size, this.setBusy});

   final String username;
   final Size size;
   final Function(bool value) setBusy;
  
  GiftsState createState() => GiftsState();
}

class GiftsState extends State<Gifts>{
  GiftsState();

  RPC _rpc;
  List<GiftCategoryModel> _categories;
  List<GiftCategoryItem> _categoriesItems;
  List<GlobalKey<GiftCategoryItemState>> _categoriesKeys;
  GiftCategoryModel _selectedCategory;

  List<GlobalKey<GiftItemState>> _itemKeys = new List<GlobalKey<GiftItemState>>();
  List<GiftModel> _giftRecords;
  int _currentGiftsPage = 1;
  List<Row> _itemsRows = new List<Row>();
  int _giftsPagesNum;
  GiftModel _selectedGift;
  bool _isPrivate = false;

  TextEditingController _messageController = TextEditingController();

  GlobalKey<ZButtonState> _previousPageKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _nextPageKey = GlobalKey<ZButtonState>();

  _onSendGift(BuildContext context) async {
    var options = {};
    options["giftId"] = _selectedGift.id;
    options["to"] = widget.username;
    options["msg"] = _messageController.text;
    options["private"] = _isPrivate;

    var res = await _rpc.callMethod("Gifts.sendGift", [options]);

    if (res["status"] == "ok"){
      print("gift sent");
      AlertManager.instance.showSimpleAlert(context: context,
          bodyText: AppLocalizations.of(context).translate("app_gifts_sendSuccess"));
    } else {
      print("ERROR");
      print(res["status"]);
      AlertManager.instance.showSimpleAlert(context: context,
          bodyText: AppLocalizations.of(context).translate("app_gifts_error"));

    }
  }

  _onCategorySelected(int id){
    print("selected category: "+id.toString());
    _selectedCategory = _categories.where((element) => element.id == id).first;
    for(int i=0; i<_categoriesKeys.length; i++)
      _categoriesKeys[i].currentState.setSelected(id);
    _getGiftsForCategory(_selectedCategory.id);
  }

  _onGiftSelected(GiftModel data){
    print("selected Gift: "+data.name);
    for(int i=0; i<_itemKeys.length; i++)
      _itemKeys[i].currentState.setSelected(data.id);

    setState(() {
      _selectedGift = data;
    });

    //todo stuff
  }

  @override
  void initState() {
    _rpc = RPC();
     _categories = new List<GiftCategoryModel>();
    _categoriesItems = new List<GiftCategoryItem>();
    _categoriesKeys = new List<GlobalKey<GiftCategoryItemState>>();
    _giftRecords = new List<GiftModel>();

    for(int i=0; i<3; i++){
      List<Widget> items = new List<Widget>();
      for (int j=0; j<3; j++){
        GlobalKey<GiftItemState> _key =  GlobalKey<GiftItemState>();
        _itemKeys.add(_key);
         items.add(GiftItem(key: _key, onSelected: _onGiftSelected,));
        }

        Row row = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        );

        _itemsRows.add(row);
      }

    _getCategories();
    super.initState();
  }
  
  _getCategories() async {
    var res = await _rpc.callMethod("Gifts.getGiftCategories");

    if (res["status"] == "ok"){
      print(res["data"]);
      setState(() {
        for(int i=0; i<res["data"].length; i++){
          if (i == 0) _selectedCategory = GiftCategoryModel.fromJSON(res["data"][i]);
          _categories.add(GiftCategoryModel.fromJSON(res["data"][i]));
          GlobalKey<GiftCategoryItemState> _key = new GlobalKey<GiftCategoryItemState>();
          _categoriesKeys.add(_key);
          _categoriesItems.add(GiftCategoryItem(key: _key, onSelected: _onCategorySelected, isSelected : i == 0, data: GiftCategoryModel.fromJSON(res["data"][i])));
        }

        _getGiftsForCategory(_selectedCategory.id);
      });
    } else {
      print("ERROR");
      print(res);
    }
  }

  _getGiftsForCategory(int id) async {
    var res = await _rpc.callMethod("Gifts.getGiftsForCategory", [_selectedCategory.id]);

    if (res["status"] == "ok"){
      _currentGiftsPage = 1;

      print(res["data"]);
      _giftRecords.clear();
      for (int i=0; i<res["data"].length; i++){
        _giftRecords.add(GiftModel.fromJSON(res["data"][i]));
      }

      print("_giftRecords.length = "+_giftRecords.length.toString());
      _giftsPagesNum = (_giftRecords.length / 9).ceil();

      _updateGiftsPage();


    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _updateGiftsPage(){
    print("_updateGiftsPage");
    for(int i=0; i<9; i++){
      var dataIndex = ((_currentGiftsPage-1) * 9) + i;
      if (dataIndex < _giftRecords.length)
        _itemKeys[i].currentState.update(_giftRecords[dataIndex]);
      else _itemKeys[i].currentState.clear();
    }

    _updatePager();
  }

  _updatePager(){
    _previousPageKey.currentState.setDisabled(_currentGiftsPage == 1);
    _nextPageKey.currentState.setDisabled(_currentGiftsPage == _giftsPagesNum);
  }

  _previousPage(){
    setState(() {
      _currentGiftsPage--;
      _updateGiftsPage();
    });
  }

  _nextPage(){
    setState(() {
      _currentGiftsPage++;
      _updateGiftsPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).canvasColor,
        height: widget.size.height,
        // width: widget.size.width,
        padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
                AppLocalizations.of(context).translateWithArgs("app_gifts_sendGift", [widget.username]),
                style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widget.size.width * 0.18,
                height: widget.size.height - 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )
                ),
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: _categoriesItems
                )
              ),
              Expanded(child:Container()),
              Container(
                padding: EdgeInsets.all(5),
                width: widget.size.width * 0.57,
                height: widget.size.height - 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )
                ),
                child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          child: ZButton(
                              key: _previousPageKey,
                              clickHandler: _previousPage,
                              iconData: Icons.arrow_back_ios,
                              iconSize: 20,
                              iconColor: Colors.blue,
                              hasBorder: false
                          )
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _itemsRows
                        ),
                        Container(
                            width: 35,
                            height: 35,
                            child: ZButton(
                                key: _nextPageKey,
                                clickHandler: _nextPage,
                                iconData: Icons.arrow_forward_ios,
                                iconSize: 20,
                                iconColor: Colors.blue,
                                hasBorder: false
                            )
                        ),
                      ],
                    )
                )
              ),
              Expanded(child:Container()),
              Container(
                width: widget.size.width * 0.24,
                height: widget.size.height - 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   _selectedGift == null ? SizedBox(width: GiftItem.myWidth, height: GiftItem.myHeight) :
                   Image.network(_selectedGift.url, width: GiftItem.myWidth, height: GiftItem.myHeight),
                    Text(AppLocalizations.of(context).translate("app_gifts_lblMessage"),
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)),
                    TextField(
                      controller: _messageController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      maxLines: 5,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: CheckboxListTile(
                          title: Text(
                            AppLocalizations.of(context).translate("app_gifts_chkBoxPrive"),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                          value: _isPrivate,
                          onChanged: (newValue) {
                            setState(() {
                              _isPrivate = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                        )
                    ),
                    Container(
                      width:  widget.size.width * 0.20,
                      height: 30,
                      child: ZButton(
                        clickHandler: (){
                          _onSendGift(context);
                        },
                        label: AppLocalizations.of(context).translate("app_gifts_btnSend"),
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    )
                  ],
                )
              )
            ],
          )
        ],
      )
    );
  }
  
  
}