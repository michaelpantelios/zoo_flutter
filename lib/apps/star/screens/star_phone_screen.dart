import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_html_css/simple_html_css.dart';
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(10), child: Icon(Icons.star, size: 60, color: Colors.orange)),
                Container(
                    width: _appSize.width - 90,
                    child: HTML.toRichText(context, AppLocalizations.of(context).translate("app_star_tl_txtHeader"), overrideStyle: {
                      "html": TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    })),
              ],
            ),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: HTML.toRichText(
                    context,
                    AppLocalizations.of(context).translateWithArgs(
                      "app_star_tl_txtStep1",
                      [DataMocker.premiumStarPhoneSettings["phoneStarGateway"].toString()],
                    ),
                    overrideStyle: {
                      "html": TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    })),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: HTML.toRichText(
                    context,
                    AppLocalizations.of(context).translateWithArgs(
                      "app_star_tl_txtStep2",
                      [UserProvider.instance.userInfo.userId.toString()],
                    ),
                    overrideStyle: {
                      "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 12),
                    })),
            Padding(
              padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
              child: HTML.toRichText(
                context,
                AppLocalizations.of(context).translateWithArgs("app_star_tl_txtCredits", [DataMocker.premiumStarPhoneSettings["phoneStarCellCost"].toString(), DataMocker.premiumStarPhoneSettings["phoneStarFixedCost"].toString(), DataMocker.premiumStarPhoneSettings["phoneStarProvider"].toString()]),
                overrideStyle: {
                  "html": TextStyle(
                    backgroundColor: Colors.white,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                },
              ),
            ),
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: _appSize.width * 0.3,
              child: RaisedButton(
                onPressed: () {
                  onBackHandler();
                },
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.arrow_back, size: 20, color: Colors.black)),
                    Text(
                      AppLocalizations.of(context).translate("app_star_tl_btnBack"),
                      style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
