import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class StarCreditScreen extends StatefulWidget{
  StarCreditScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  StarCreditScreenState createState() => StarCreditScreenState();

}

class StarCreditScreenState extends State<StarCreditScreen>{
  StarCreditScreenState();

  String _product;

  buyProduct(){
    print("buy permanent subscription");
  }

  @override
  void initState() {
    _product = "star1";
    super.initState();
  }
  
  getProductOption(String prodid){
    String label = AppLocalizations.of(context).translate("app_star_cc_"+prodid);
    return Container(
            width: widget._appSize.width * 0.4,
            child: RadioListTile<String>(
              title: Text(
                  label,
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
            ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget._appSize.height-10,
      color: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.star,
                      size: 60, color: Colors.orange)),
              Container(
                  width: widget._appSize.width - 90,
                  child: Html(
                      data: AppLocalizations.of(context).translate("app_star_cc_txtHeader"),
                      style: {
                        "html": Style(
                            backgroundColor: Colors.white,
                            color: Colors.black,
                            fontSize: FontSize.large,
                            textAlign: TextAlign.justify
                        ),
                      })
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child:  Center(
                child: Text(AppLocalizations.of(context).translate("app_star_cc_txtSubHeader"),
                    style: Theme.of(context).textTheme.bodyText1)
            ),
          ),

          getProductOption("star1"),
          getProductOption("star3"),
          getProductOption("star6"),
          getProductOption("star12"),
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
                          AppLocalizations.of(context).translate("app_star_cc_btnCancel"),
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
                          AppLocalizations.of(context).translate("app_star_cc_btnGo"),
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
      )
    );
  }
}