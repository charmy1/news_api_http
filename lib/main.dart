import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'router/router.gr.dart' as r;

import 'injection.dart';

//fvm flutter packages pub run build_runner watch --delete-conflicting-outputs


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Environment.prod);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
        ),

        builder: ExtendedNavigator.builder<r.Router>(
          router: r.Router(),
          name: "rootNav",
        ),
        routes: {});
  }
}

