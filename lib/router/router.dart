import 'package:auto_route/auto_route_annotations.dart';
import 'package:new_api_http_flutter/presentation/detail_page.dart';
import 'package:new_api_http_flutter/presentation/home_page.dart';


@MaterialAutoRouter(
    generateNavigationHelperExtension: true,
    routesClassName: 'Routes',
    routes: [
      AdaptiveRoute(page: HomePage, initial: true),
      AdaptiveRoute(page: DetailPage,),


    ])
class $Router {}
