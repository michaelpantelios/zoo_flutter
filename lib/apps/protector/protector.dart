import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/coins_cost.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

enum CostTypes { forumSticky, oldStats, add_friend, mailNew, send_gift }

class Protector extends StatefulWidget {
  Protector({this.costType, this.size, this.onClose});

  final Function(dynamic retValue) onClose;
  final CostTypes costType;
  final Size size;

  ProtectorState createState() => ProtectorState();
}

class ProtectorState extends State<Protector> {
  ProtectorState();

  Map<CostTypes, int> _costs = {
    CostTypes.forumSticky: CoinsCost.STICKY_FORUM,
    CostTypes.oldStats: CoinsCost.PROFILE_STATISTICS,
    CostTypes.add_friend: CoinsCost.MESSENGER_ADD_FRIEND,
    CostTypes.mailNew: CoinsCost.MAIL_NEW,
    CostTypes.send_gift: CoinsCost.SEND_GIFT,
  };

  bool _enoughCoins;

  @override
  void dispose() {
    UserProvider.instance.removeListener(onUserAcquiredCoins);
    super.dispose();
  }

  @override
  void initState() {
    _enoughCoins = UserProvider.instance.userInfo.coins >= _costs[widget.costType];
    UserProvider.instance.addListener(onUserAcquiredCoins);
    super.initState();
  }

  onUserAcquiredCoins() {
    setState(() {
      _enoughCoins = UserProvider.instance.userInfo.coins >= _costs[widget.costType];
    });
  }

  getCostString() {
    return AppLocalizations.of(context).translateWithArgs("app_protector_header", [_costs[widget.costType].toString()]);
  }

  getNotEnoughCoinsText() {
    return !_enoughCoins
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(AppLocalizations.of(context).translate("app_protector_noCoins_subHeader"), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal)),
          )
        : Container();
  }

  getCoinsPrompt() {
    return _enoughCoins
        ? Container()
        : ZButton(
            minWidth: 150,
            height: 50,
            buttonColor: Colors.blue,
            label: AppLocalizations.of(context).translate("app_protector_getCoins"),
            labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            clickHandler: () {
              widget.onClose("cancel");
              PopupManager.instance.show(context: context, popup: PopupType.Coins);
            },
          );
  }

  getBody() {
    return !_enoughCoins
        ? Container()
        : Html(data: AppLocalizations.of(context).translateWithArgs("app_protector_Body", [_costs[widget.costType].toString()]), style: {
            "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
          });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(5),
        width: widget.size.width - 10,
        height: widget.size.height - 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(getCostString(), style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Text(AppLocalizations.of(context).translateWithArgs("app_protector_userCoins", [UserProvider.instance.userInfo.coins.toString()]), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
            getNotEnoughCoinsText(),
            Padding(padding: EdgeInsets.symmetric(vertical: 5), child: getCoinsPrompt()),
            Padding(padding: EdgeInsets.symmetric(vertical: 5), child: getBody()),
            Container(
                width: widget.size.width - 40,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: _enoughCoins,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: ZButton(
                              clickHandler: () {
                                widget.onClose("ok");
                              },
                              minWidth: 140,
                              height: 40,
                              buttonColor: Colors.green,
                              label: AppLocalizations.of(context).translate("app_protector_continue"),
                              labelStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ZButton(
                        clickHandler: () {
                          widget.onClose("cancel");
                        },
                        minWidth: 140,
                        height: 40,
                        buttonColor: Colors.red,
                        label: AppLocalizations.of(context).translate("app_protector_cancel"),
                        labelStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
