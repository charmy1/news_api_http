import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_api_http_flutter/application/news_bloc/news_bloc.dart';

class TopMenuTiles extends StatelessWidget {
  String name;

  int index;

  TopMenuTiles({
    super.key,
    required this.name,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding:
          const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Card(
            color: Colors.blueGrey,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
            ),
            child: BlocBuilder<NewsBloc, NewsState>(
              bloc: BlocProvider.of<NewsBloc>(context),
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    context
                        .read<NewsBloc>()
                        .add(const NewsEvent.pageCountEventReset());
                    context
                        .read<NewsBloc>()
                        .add(NewsEvent.sourceChangedEvent(source: name));
                    context
                        .read<NewsBloc>()
                        .add(const NewsEvent.filterNewsBySourcesEvent());
                  },
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}