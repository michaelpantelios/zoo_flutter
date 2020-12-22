import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class EmoticonsLayer extends StatelessWidget {
  final List<String> _emoticons = List.generate(60, (index) => "/assets/images/emoticons/$index.gif");
  EmoticonsLayer();
  @override
  Widget build(BuildContext context) {
    var tableRows = 0;
    return Container(
      // width: myWidth,
      height: 250,
      child: Table(
        children: _tableChildren(),
      ),
    );
  }

  _tableChildren() {
    List<Widget> arr = [];
    List<TableRow> tableRows = [];
    for (var i = 0; i < _emoticons.length - 1; i++) {
      if (i > 0 && i % 10 == 0) {
        print("table row: ${i} ${arr.length}");
        tableRows.add(TableRow(children: arr));
        arr = [];
      } else {
        arr.add(_emoticon(i));
      }
    }

    return tableRows;
  }

  Widget _emoticon(index) {
    var emoIndex = index + 1;
    var htmlData = """
          <img src='${_emoticons[emoIndex]}'>
          </img>
         """;
    return GestureDetector(
      onTap: () {
        print("taped : $emoIndex");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[800],
            width: 1,
          ),
        ),
        child: Center(
          child: Html(
            data: htmlData,
            style: {
              "html": Style(textAlign: TextAlign.center),
            },
          ),
        ),
      ),
    );
  }
}
