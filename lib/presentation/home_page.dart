import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_api_http_flutter/application/news_bloc/news_bloc.dart';
import 'package:new_api_http_flutter/injection.dart';
import 'package:new_api_http_flutter/presentation/widgets/home/home_page_scaffold.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<NewsBloc>()..add(const NewsEvent.readNewsEvent()),
      child: HomePageScaffold(),
    );
  }
}






