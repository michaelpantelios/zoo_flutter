import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/coins/screens/coins_credit_screen.dart';
import 'package:zoo_flutter/apps/coins/screens/coins_paypal_screen.dart';
import 'package:zoo_flutter/apps/coins/screens/coins_paysafe_screen.dart';
import 'package:zoo_flutter/apps/coins/screens/coins_phone_screen.dart';
import 'package:zoo_flutter/apps/coins/screens/coins_sms_screen.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

enum PurchaseOption { sms, phone, paypal, card, paysafe }

class Coins extends StatefulWidget {
  final Size size;
  Coins({Key key, @required this.size});

  CoinsState createState() => CoinsState();
}

class CoinsState extends State<Coins> {
  CoinsState({Key key});

  PurchaseOption _purchaseOption;
  int screenToShow = 0;

  @override
  void initState() {
    _purchaseOption = PurchaseOption.sms;
    super.initState();
  }

  onBackHandler() {
    setState(() {
      screenToShow = 0;
    });
  }

  changeScreen() {
    setState(() {
      switch (_purchaseOption) {
        case PurchaseOption.sms:
          screenToShow = 1;
          break;
        case PurchaseOption.phone:
          screenToShow = 2;
          break;
        case PurchaseOption.paypal:
          screenToShow = 3;
          break;
        case PurchaseOption.card:
          screenToShow = 4;
          break;
        case PurchaseOption.paysafe:
          screenToShow = 5;
          break;
      }
    });
  }

  getListTileOption(Widget tileIcon, String titleCode, PurchaseOption optionValue) {
    return Row(
      children: [
        SizedBox(width: 10),
        Container(width: 60, margin: EdgeInsets.only(left: 10), child: tileIcon),
        Container(
            width: widget.size.width - 100,
            child: RadioListTile<PurchaseOption>(
              title: Text(AppLocalizations.of(context).translate(titleCode), style: TextStyle(fontSize: 14.0, color: Color(0xff000000), fontWeight: FontWeight.normal)),
              selected: optionValue == _purchaseOption,
              value: optionValue,
              groupValue: _purchaseOption,
              onChanged: (PurchaseOption value) {
                setState(() {
                  _purchaseOption = value;
                  print("_purchaseOption = " + _purchaseOption.toString());
                });
              },
            ))
      ],
    );
  }

  getHomeScreen() {
    return Container(
        color: Color(0xFFffffff),
        height: widget.size.height - 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/coins/coins_header.png",
                ),
                Positioned(
                  top: 20,
                  left: 220,
                  child: Container(
                    width: 300,
                    // height: 100,
                    child: Text(
                      AppLocalizations.of(context).translate("app_coins_pm_txtHeader"),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff393e54),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                width: 584,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff9598a4),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    getListTileOption(FaIcon(FontAwesomeIcons.sms, size: 40, color: Colors.blue), "app_coins_pm_pm1", PurchaseOption.sms),
                    SizedBox(height: 10),
                    getListTileOption(FaIcon(FontAwesomeIcons.phone, size: 40, color: Colors.red), "app_coins_pm_pm2", PurchaseOption.phone),
                    SizedBox(height: 10),
                    getListTileOption(FaIcon(FontAwesomeIcons.ccPaypal, size: 40, color: Colors.blue), "app_coins_pm_pm3", PurchaseOption.paypal),
                    SizedBox(height: 10),
                    getListTileOption(FaIcon(FontAwesomeIcons.solidCreditCard, size: 40, color: Colors.deepPurple), "app_coins_pm_pm4", PurchaseOption.card),
                    SizedBox(height: 10),
                    getListTileOption(FaIcon(FontAwesomeIcons.creditCard, size: 40, color: Colors.green), "app_coins_pm_pm5", PurchaseOption.paysafe),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 40, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translateWithArgs(
                        "app_coins_pm_lblCoins",
                        [
                          UserProvider.instance.userInfo.coins.toString(),
                        ],
                      ),
                      style: TextStyle(
                        color: Color(0xffff8400),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: GestureDetector(
                            onTap: () => changeScreen(),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                width: 140,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Color(0xff3c8d40),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 28),
                                      child: Text(
                                        AppLocalizations.of(context).translate("app_coins_pm_btnContinue"),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset("assets/images/coins/continue_icon.png"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    switch (screenToShow) {
      case 0:
        return getHomeScreen();
      case 1:
        return CoinsSmsScreen(onBackHandler, widget.size);
      case 2:
        return CoinsPhoneScreen(onBackHandler, widget.size);
      case 3:
        return CoinsPayPalScreen(onBackHandler, widget.size);
      case 4:
        return CoinsCreditScreen(onBackHandler, widget.size);
      case 5:
        return CoinsPaySafeScreen(onBackHandler, widget.size);
      default:
        return Container();
    }
  }
}
