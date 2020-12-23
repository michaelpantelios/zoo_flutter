import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class ChatEmoticonsLayer extends StatelessWidget {
  List<String> emoSymbols = [
    ''
  ]
  static List<dynamic> emoticons = List.generate(
      60,
      (index) => {
            "index": index,
            "path": "/assets/images/emoticons/${index + 1}.gif",
            "symbol": "/assets/images/emoticons/${index + 1}.gif",
          });

  final Function(int index) onSelected;
  ChatEmoticonsLayer({this.onSelected});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 8,
        children: emoticons.map((e) => _emoticon(e["index"])).toList(),
        childAspectRatio: 16 / 9,
      ),
    );
  }

  Widget _emoticon(emoIndex) {
    var htmlData = """
          <img src='${emoticons[emoIndex]["path"]}'>
          </img>
         """;
    return GestureDetector(
      onTap: () {
        print("taped : $emoIndex");
        onSelected(emoIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[800],
            width: 0.1,
          ),
        ),
        child: Center(
          child: IgnorePointer(
            child: Html(
              data: htmlData,
              style: {
                "html": Style(textAlign: TextAlign.center),
              },
            ),
          ),
        ),
      ),
    );
  }
}
