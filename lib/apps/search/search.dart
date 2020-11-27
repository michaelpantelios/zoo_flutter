import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/apps/search/search_quick.dart';
import 'package:zoo_flutter/apps/search/search_by_username.dart';

class Search extends StatelessWidget {
  Search();

  @override
  Widget build(BuildContext context) {
     return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SearchQuick(),
             flex: 1,
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  AppLocalizations.of(context)
                      .translate("app_search_txtOR"),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
          ),
          Flexible(
            child: SearchByUsername(),
             flex: 1,
          )

        ],
      ),
    );
  }
}
