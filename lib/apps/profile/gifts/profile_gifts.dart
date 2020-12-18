import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/models/gifts/user_gift_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/profile/gifts/profile_gift_thumb.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/apps/profile/gifts/profile_gifts_page.dart';

class ProfileGifts extends StatefulWidget {
  ProfileGifts({Key key, this.userInfo, this.giftsNum, this.myWidth, this.isMe}) : super(key: key);

  final UserInfo userInfo;
  final int giftsNum;
  final double myWidth;
  final bool isMe;

  ProfileGiftsState createState() => ProfileGiftsState(key: key);
}

class ProfileGiftsState extends State<ProfileGifts>{
  ProfileGiftsState({Key key});

  RPC _rpc;
  List<UserGiftInfo> _gifts;
  int _cols;
  int _rows = 2;
  int _itemsPerPage;

  int _currentPageIndex = 1;
  int _totalPages = 0;

  int scrollFactor = 1;
  PageController _pageController;

  List<List<UserGiftInfo>> _giftThumbPages = new List<List<UserGiftInfo>>();

  GlobalKey<ZButtonState> _previousPageButtonKey;
  GlobalKey<ZButtonState> _nextPageButtonKey;

  onScrollLeft(){
    _previousPageButtonKey.currentState.isDisabled = true;
    _pageController.previousPage(curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex--;
    });
  }

  onScrollRight(){
    _nextPageButtonKey.currentState.isDisabled = true;
    _previousPageButtonKey.currentState.isHidden = false;
    _pageController.nextPage(curve: Curves.linear, duration: Duration(milliseconds: 500));
    setState(() {
      _currentPageIndex++;
    });
  }

  _scrollListener() {
    if (_pageController.offset >= _pageController.position.maxScrollExtent &&
        !_pageController.position.outOfRange) {
      setState(() {
        _nextPageButtonKey.currentState.isDisabled = true;
      });
    }

    if (_pageController.offset < _pageController.position.maxScrollExtent && _pageController.offset > _pageController.position.minScrollExtent)
      setState(() {
        _nextPageButtonKey.currentState.isDisabled = false;
        _previousPageButtonKey.currentState.isDisabled = false;
      });

    if (_pageController.offset <= _pageController.position.minScrollExtent &&
        !_pageController.position.outOfRange) {
      setState(() {
        _previousPageButtonKey.currentState.isDisabled = true;
      });
    }
  }
  
  onSenderClickHandler(int senderId){
    print("lets open :"+senderId.toString());
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _nextPageButtonKey = GlobalKey<ZButtonState>();
    _previousPageButtonKey = GlobalKey<ZButtonState>();
    
    _gifts = new List<UserGiftInfo>();
    _cols = (widget.myWidth / ProfileGiftThumb.size.width).floor();
    _itemsPerPage = _cols * _rows;

    _currentPageIndex = 1;
    _totalPages = (_gifts.length / _itemsPerPage).ceil();

    _pageController = PageController();
    _pageController.addListener(_scrollListener);

    _rpc = RPC();

    getGifts();
  }

  getGifts() async {
    var res = await _rpc.callMethod("Gifts.getUserGifts", [widget.userInfo.username]);

    if (res["status"] == "ok") {

      var records = res["data"];
      _totalPages = (records.length / _itemsPerPage).ceil();
      print("records.length = "+records.length.toString());

      setState(() {
        int index = -1;
        for(int i=0; i<_totalPages; i++){
          List<UserGiftInfo> pageItems = new List<UserGiftInfo>();
          for(int j=0; j<_itemsPerPage; j++){
            index++;
            if (index < records.length)
              pageItems.add(UserGiftInfo.fromJSON(records[index]));
          }
          _giftThumbPages.add(pageItems);
        }
      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.myWidth,
          height: 30,
          color: Colors.orange[700],
          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
          child: Text(AppLocalizations.of(context).translateWithArgs("app_profile_lblGifts", [widget.giftsNum.toString()]),
          style: TextStyle(color:Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.orangeAccent[50],
            border: Border.all(color: Colors.orange[700], width: 1),
          ),
          child:
          widget.giftsNum == 0
              ? Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                  child: Text(
                      widget.isMe
                          ? AppLocalizations.of(context)
                          .translate("app_profile_youHaveNoGifts")
                          : AppLocalizations.of(context)
                          .translateWithArgs("app_profile_noGifts",
                          [widget.userInfo.username]),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))))
              : Column(
              children: [
                  Container(
                      width: widget.myWidth,
                      height: _rows * (ProfileGiftThumb.size.height + 10) + 10,
                      padding: EdgeInsets.all(5),
                      child: Center(
                          child:
                          PageView.builder(
                              itemBuilder: (BuildContext context, int index){
                                return ProfileGiftsPage(
                                  pageData: _giftThumbPages[index],
                                  rows: _rows,
                                  cols: _cols,
                                  myWidth: widget.myWidth - 20,
                                  onClickHandler:(int photoId){},
                                );
                              },
                              pageSnapping: true,
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              itemCount: _totalPages
                          )
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _totalPages > 1 ? ZButton(
                        key: _previousPageButtonKey,
                        iconData: Icons.arrow_back_ios,
                        iconColor: Colors.blue,
                        iconSize: 30,
                        clickHandler: onScrollLeft,
                        startDisabled: true,
                      ) : Container(),
                      Container(
                        height: 30,
                        width: 120,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Center(
                                child: Html(data: AppLocalizations.of(context).translateWithArgs(
                                    "pager_label", [_currentPageIndex.toString(), _totalPages.toString()]),
                                    style: {
                                      "html": Style(
                                          backgroundColor: Colors.white,
                                          color: Colors.black,
                                          textAlign: TextAlign.center),
                                    }))),
                      ),
                      _totalPages > 1 ? ZButton(
                          key: _nextPageButtonKey,
                          iconData: Icons.arrow_forward_ios,
                          iconColor: Colors.blue,
                          iconSize: 30,
                          clickHandler: onScrollRight
                      ): Container()
                  ],
                )
              ],
          )
        )
      ],
    );
  }
}