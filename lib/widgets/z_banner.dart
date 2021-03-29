// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart' show rootBundle;

class ZBanner extends StatefulWidget {
  ZBanner({@required this.bannerId, @required this.bannerSize});

  final String bannerId;
  final Size bannerSize;

  ZBannerState createState() => ZBannerState();
}

class ZBannerState extends State<ZBanner> {
  ZBannerState();

  final html.IFrameElement _bannerFrameElement = html.IFrameElement();
  Widget _bannerFrameWidget;

  String fileHtmlContents = "";

  @override
  void initState() {
    print("banner got source = "+widget.bannerId);

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('bannerIframeElement'+widget.bannerId, (int viewId) => _bannerFrameElement);
    _bannerFrameWidget = HtmlElementView(viewType: 'bannerIframeElement'+widget.bannerId);

    getAdTagSource(widget.bannerId);

    super.initState();
  }

  Future<void> getAdTagSource(String id) async {
    String htmlString = await rootBundle.loadString('assets/data/banners/sidestamp$id.html');

    setState(() {
      _bannerFrameElement.srcdoc = htmlString;
      _bannerFrameElement.style.border = "none";
      _bannerFrameElement.style.padding = "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              new BoxShadow(color: Color(0x15000000), offset: new Offset(4.0, 4.0), blurRadius: 5, spreadRadius: 2),
            ],
          ),
          width: widget.bannerSize.width,
          height: widget.bannerSize.height,
          child: ClipRRect(borderRadius: BorderRadius.circular(9), child: _bannerFrameWidget )
    );
  }
}
