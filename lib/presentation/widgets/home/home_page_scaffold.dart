import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_api_http_flutter/presentation/widgets/home/top_selection_widget.dart';

import '../search_widget.dart';
import 'news_items.dart';

class HomePageScaffold extends StatefulWidget {
  @override
  _HomePageScaffoldState createState() => _HomePageScaffoldState();
}

class _HomePageScaffoldState extends State<HomePageScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text("News Api"),
          actions: const <Widget>[
            //here add menu for filter
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Column(
          children: <Widget>[
            const SearchWidget(),
            const TopSelection(
              list: [
                "general",
                "entertainment",
                "health",
                "science",
                "sports",
                "technology",
                "business"
              ],
            ),
            Expanded(child: NewsItems()),
            // TestWidget()
          ],
        ));
  }
}
