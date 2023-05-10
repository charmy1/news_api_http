import 'package:auto_route/auto_route.dart';
import 'package:new_api_http_flutter/presentation/detail_page.dart';
import 'package:new_api_http_flutter/presentation/home_page.dart';
import 'package:new_api_http_flutter/router/router.gr.dart';

/*@AutoRouterConfig(
  generateNavigationHelperExtension: true,
  routesClassName: 'Routes',
)
class Router extends $Router {
  @override
  RouteType get defaultRouteType => RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AdaptiveRoute(page: HomePage.page, path: '/'),
    AdaptiveRoute(page: DetailPage.page),
  ];
}*/

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {

  @override
  List<AutoRoute> get routes => [
    //HomeScreen is generated as HomeRoute because
    //of the replaceInRouteName property
    AutoRoute(initial: true, page: HomeRoute.page),

  ];
}
