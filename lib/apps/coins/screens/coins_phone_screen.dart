import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class CoinsPhoneScreen extends StatelessWidget {
  CoinsPhoneScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _appSize.height - 10,
        color: Color(0xFFffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/coins/phone_header.png",
            ),
            Padding(
                padding: EdgeInsets.only(left: 45, bottom: 5, right: 5, top: 25),
                child: Html(data: AppLocalizations.of(context).translateWithArgs("app_coins_tl_txtStep1", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsGateway"]]), style: {
                  "html": Style(fontSize: FontSize.medium, color: Color(0xff393e54), textAlign: TextAlign.left),
                })),
            Padding(
                padding: EdgeInsets.only(left: 45, bottom: 5, right: 5, top: 5),
                child: Html(data: AppLocalizations.of(context).translateWithArgs("app_coins_tl_txtStep2", ["<span style='color: red'>" + UserProvider.instance.userInfo.userId.toString() + "</span>"]), style: {
                  "html": Style(color: Color(0xff393e54), fontSize: FontSize.medium, textAlign: TextAlign.left),
                })),
            Padding(
                padding: EdgeInsets.only(left: 55, bottom: 5, right: 5, top: 25),
                child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_tl_credits_fixed", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsFixedCost"] + " " + DataMocker.premiumCoinsPhoneSettings["phoneCoinsProvider"]]),
                    style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
            Padding(
                padding: EdgeInsets.only(left: 55, bottom: 5, right: 5, top: 5),
                child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_tl_credits_cell", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsCellCost"] + " " + DataMocker.premiumCoinsPhoneSettings["phoneCoinsProvider"]]),
                    style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
            Expanded(child: Container()),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 20),
                  child: GestureDetector(
                    onTap: () => onBackHandler(),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 140,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xfff7a738),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                width: 25,
                                height: 25,
                                child: Image.asset("assets/images/coins/back_icon.png"),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context).translate("app_coins_sm_btnBack"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
