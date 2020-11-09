import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/control/user.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';


class CoinsPaySafeScreen extends StatefulWidget{
  CoinsPaySafeScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  CoinsPaySafeScreenState createState() => CoinsPaySafeScreenState();
}

class CoinsPaySafeScreenState extends State<CoinsPaySafeScreen>{
  CoinsPaySafeScreenState();

  List<DataRow> products = new List<DataRow>();
  String _product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _product = "combo1280";
  }

  purchaseProduct(){
    print("Buy this product:"+_product);
  }

  DataRow createProductRow(String prodid){
    var productStringsArray = AppLocalizations.of(context).translate("app_coins_ps_"+prodid).split("|");
    List<DataCell> cells = new List<DataCell>();

    cells.add( new DataCell(
        Container(
          // width: 300,
            child: RadioListTile<String>(
              title: Text(
                  productStringsArray[0],
                  style: Theme.of(context).textTheme.bodyText1),
              selected: _product == prodid,
              value: prodid,
              groupValue: _product,
              onChanged: (String value) {
                setState(() {
                  print("value = "+value);
                  _product = value;
                });
              },
            ))
    ));

    cells.add(new DataCell(
        Text(productStringsArray[1],
            style: Theme.of(context).textTheme.bodyText1)
    ));

    cells.add(new DataCell(
        Text(productStringsArray[2],
            style: Theme.of(context).textTheme.bodyText1)
    ));
    DataRow row = new DataRow(cells : cells);

    return row;
  }

  @override
  Widget build(BuildContext context) {

    products.clear();
    products.add(createProductRow("coins350"));
    if (!User.instance.userInfo.star)
      products.add(createProductRow("combo560"));
    products.add(createProductRow("coins800"));
    if (!User.instance.userInfo.star)
      products.add(createProductRow("combo1280"));

    return Container(
        height: widget._appSize.height - 10,
        color: Theme.of(context).canvasColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FaIcon(FontAwesomeIcons.coins,
                        size: 50, color: Colors.orange)),
                Container(
                    width: widget._appSize.width - 80,
                    child: Html(
                        data: AppLocalizations.of(context).translate("app_coins_ps_txtHeader"),
                        style: {
                          "html": Style(
                              backgroundColor: Colors.white,
                              color: Colors.black,
                              fontSize: FontSize.large
                          ),
                        })
                )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5),
            child: RichText(
              text: TextSpan(
                  text: AppLocalizations.of(context).translate("app_coins_ps_paysafe_link1"),
                  style: Theme.of(context).textTheme.headline4 ,
              children: <TextSpan>[
                TextSpan(
                  text: AppLocalizations.of(context).translate("app_coins_ps_paysafe_link2"),
                  style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.normal),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'http://www.paysafecard.com/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  children: <TextSpan>[
                    TextSpan(
                      text: AppLocalizations.of(context).translate("app_coins_ps_paysafe_link3"),
                      style: Theme.of(context).textTheme.headline4 ,
                    )
                  ]
                )
               ]
              )
              )
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Html(
                    data: AppLocalizations.of(context).translate( User.instance.userInfo.star ? "app_coins_ps_subHeaderStar" : "app_coins_ps_subHeaderNonStar"),
                    style: {
                      "html": Style(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: FontSize.medium,
                          textAlign: TextAlign.left
                      ),
                    })
            ),
            DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_ps_txtChooseBundle"),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_ps_txtPrice"),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_ps_txtDiscount"),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
              rows: products,
            ),
            Expanded(child: Container()),
            Padding(
                padding:EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed:(){
                        widget.onBackHandler();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding( padding: EdgeInsets.only(right: 5), child:Icon(Icons.arrow_back, size: 20, color:Colors.black) ),
                          Text(
                            AppLocalizations.of(context).translate("app_coins_ps_btnBack"),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width:20),
                    RaisedButton(
                      onPressed:(){
                        purchaseProduct();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("app_coins_ps_btnContinue"),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Icon(Icons.arrow_right_alt, size: 20, color:Colors.black)
                        ],
                      ),
                    )
                  ],
                )
            )
          ],
        )
    );
  }

}