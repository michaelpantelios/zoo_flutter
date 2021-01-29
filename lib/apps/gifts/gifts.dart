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
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';

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
    if (_selectedGift == null){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_gifts_noGiftSelected"));
      return;
    }

    PopupManager.instance.show(context: context, options: CostTypes.send_gift, popup: PopupType.Protector, callbackAction: (retVal)=>{
      if (retVal == "ok")
        _doSendGift(context)
    });
  }

  _doSendGift(BuildContext context) async {
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
      print(res["errorMsg"]);
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
        color: Color(0xFFffffff),
        height: widget.size.height,
        // width: widget.size.width,
        padding: EdgeInsets.all(15),
      child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(AppLocalizations.of(context).translate("app_gifts_categories_lbl"),
                          style: TextStyle(color: Color(0xff9598A4), fontSize: 16, fontWeight: FontWeight.normal))
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: widget.size.width * 0.24,
                      height: widget.size.height - 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          new BoxShadow(color: Color(0x33000000), offset: new Offset(0.5, 0.5), blurRadius: 2, spreadRadius: 2),
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _categoriesItems
                      )
                  )
                ],
              ),
              Expanded(child:Container()),
              Container(
                padding: EdgeInsets.all(5),
                width: widget.size.width * 0.52,
                height: widget.size.height - 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: Color(0xff9597A3),
                      width: 2,
                    )
                ),
                child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 38,
                          height: 35,
                          child: ZButton(
                              key: _previousPageKey,
                              clickHandler: _previousPage,
                              iconData: Icons.arrow_back_ios,
                              iconSize: 30,
                              iconColor: Colors.blue,
                              hasBorder: false
                          )
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _itemsRows
                        ),
                        Container(
                            width: 38,
                            height: 35,
                            child: ZButton(
                                key: _nextPageKey,
                                clickHandler: _nextPage,
                                iconData: Icons.arrow_forward_ios,
                                iconSize: 30,
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
                height: widget.size.height - 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(AppLocalizations.of(context).translate("app_gifts_selection_lbl"),
                            style: TextStyle(color: Color(0xff9598A4), fontSize: 16, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left)
                    ),
                   Container(
                     height: 125,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(9),
                       boxShadow: [
                         new BoxShadow(color: Color(0x33000000), offset: new Offset(0.5, 0.5), blurRadius: 2, spreadRadius: 2),
                       ],
                     ),
                     child: Center(
                       child: _selectedGift == null ? Container() :
                       Image.network(_selectedGift.url, width: GiftItem.myWidth, height: GiftItem.myHeight),
                     )
                   ),
                    Expanded(child: Container()),
                    Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(AppLocalizations.of(context).translate("app_gifts_lblMessage"),
                            style: TextStyle(color: Color(0xff9598A4), fontSize: 16, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left)
                    ),
                    Container(
                        height: 145,
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            new BoxShadow(color: Color(0x33000000), offset: new Offset(0.5, 0.5), blurRadius: 2, spreadRadius: 2),
                          ],
                        ),
                        child: Center(
                          child:  TextField(
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: AppLocalizations.of(context).translate("textfield_hint"),
                              border: InputBorder.none,
                            ),
                            controller: _messageController,
                            maxLines: 7,
                          ),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            AppLocalizations.of(context).translate("app_gifts_chkBoxPrive"),
                            style: TextStyle(color: Color(0xff9598A4), fontWeight: FontWeight.normal, fontSize: 12),
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
                    ZButton(
                        minWidth:  160,
                        height: 40,
                        buttonColor: Color(0xff3B8D3F),
                        clickHandler: (){
                          _onSendGift(context);
                        },
                        iconPath: "assets/images/gifts/gift_icon.png",
                        iconSize: 30,
                        iconColor: Colors.white,
                        iconPosition: ZButtonIconPosition.right,
                        label: AppLocalizations.of(context).translate("app_gifts_btnSend"),
                        labelStyle: Theme.of(context).textTheme.button,
                      )

                  ],
                )
              )
            ],
          )

    );
  }
  
  
}