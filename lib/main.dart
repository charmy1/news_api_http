import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:new_api_http_flutter/router/router.dart';
import 'router/router.gr.dart' as r;

import 'injection.dart';

//fvm flutter packages pub run build_runner watch --delete-conflicting-outputs
//todo search,detail page ,
// sort by recent first is default

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
   configureInjection(Environment.prod);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
      routerConfig: AppRouter().config(),
    );
  }
}

