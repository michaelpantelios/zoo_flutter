import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class StarPayPalScreen extends StatelessWidget{
  StarPayPalScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  buyProduct(){
    print("buy permanent subscription");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _appSize.height-10,
      color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.star,
                      size: 60, color: Colors.orange)),
              Container(
                  width: _appSize.width - 90,
                  child: Html(
                      data: AppLocalizations.of(context).translate("app_star_pp_txtHeader"),
                      style: {
                        "html": Style(
                            backgroundColor: Colors.white,
                            color: Colors.black,
                            fontSize: FontSize.large,
                        ),
                      })
              ),
            ],
          ),
          Expanded(child: Container()),
          Padding(
              padding:EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed:(){
                      onBackHandler();
                    },
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding( padding: EdgeInsets.only(right: 5), child:Icon(Icons.arrow_back, size: 20, color:Colors.black) ),
                        Text(
                          AppLocalizations.of(context).translate("app_star_pp_btnBack"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width:20),
                  RaisedButton(
                    onPressed:(){
                      buyProduct();
                    },
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("app_star_pp_btnGo"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Icon(Icons.arrow_forward_rounded, size: 20, color:Colors.black)
                      ],
                    ),
                  )
                ],
              )
          )

        ],
      ),
    );

  }
}