import 'package:flutter/material.dart';
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
        color: Theme.of(context).canvasColor,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(10), child: Icon(Icons.star, size: 60, color: Colors.orange)),
                Container(
                    width: _appSize.width - 90,
                    child: Html(data: AppLocalizations.of(context).translate("app_star_tl_txtHeader"), style: {
                      "html": Style(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontSize: FontSize.large,
                      ),
                    })),
              ],
            ),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: Html(data: AppLocalizations.of(context).translateWithArgs("app_star_tl_txtStep1", [DataMocker.premiumStarPhoneSettings["phoneStarGateway"]]), style: {
                  "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.left),
                })),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: Html(data: AppLocalizations.of(context).translateWithArgs("app_star_tl_txtStep2", [UserProvider.instance.userInfo.userId]), style: {
                  "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.left),
                })),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: Html(data: AppLocalizations.of(context).translateWithArgs("app_star_tl_txtCredits", [DataMocker.premiumStarPhoneSettings["phoneStarCellCost"], DataMocker.premiumStarPhoneSettings["phoneStarFixedCost"], DataMocker.premiumStarPhoneSettings["phoneStarProvider"]]), style: {
                  "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.left),
                })),
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
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
