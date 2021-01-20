import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class StarPhoneScreen extends StatelessWidget {
  StarPhoneScreen(this.onBackHandler, this._appSize);

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
            Stack(
              children: [
                Image.asset(
                  "assets/images/star/phone_header.png",
                ),
                Positioned(
                  top: 20,
                  left: 220,
                  child: Container(
                    width: 330,
                    // height: 100,
                    child: Html(
                      data: AppLocalizations.of(context).translate("app_star_tl_txtHeader"),
                      style: {"html": Style(color: Colors.black, fontSize: FontSize.large, fontWeight: FontWeight.w500, textAlign: TextAlign.left)},
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.only(left: 30, bottom: 5, right: 5, top: 5),
                child: Html(data: AppLocalizations.of(context).translateWithArgs("app_star_tl_txtStep1", [DataMocker.premiumStarPhoneSettings["phoneStarGateway"].toString()]), style: {
                  "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, fontWeight: FontWeight.w500, textAlign: TextAlign.left),
                })),
            Padding(
                padding: EdgeInsets.only(left: 30, bottom: 5, right: 5, top: 5),
                child: Html(data: AppLocalizations.of(context).translateWithArgs("app_star_tl_txtStep2", ["<span style='color: red'>" + UserProvider.instance.userInfo.userId.toString() + "</span>"]), style: {
                  "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, fontWeight: FontWeight.w500, textAlign: TextAlign.left),
                })),
            Padding(
                padding: EdgeInsets.only(left: 30, bottom: 5, right: 5, top: 5),
                child: Html(
                    data: AppLocalizations.of(context)
                        .translateWithArgs("app_star_tl_txtCredits", [DataMocker.premiumStarPhoneSettings["phoneStarCellCost"].toString(), DataMocker.premiumStarPhoneSettings["phoneStarFixedCost"].toString(), DataMocker.premiumStarPhoneSettings["phoneStarProvider"].toString()]),
                    style: {
                      "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, fontWeight: FontWeight.w500, textAlign: TextAlign.left),
                    })),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Row(
                children: [
                  Spacer(),
                  GestureDetector(
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
                                AppLocalizations.of(context).translate("app_star_tl_btnBack"),
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
                ],
              ),
            )
          ],
        ));
  }
}
