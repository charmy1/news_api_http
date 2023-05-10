import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_api_http_flutter/application/news_bloc/news_bloc.dart';
import 'package:new_api_http_flutter/domain/news/article_model.dart';
import 'package:new_api_http_flutter/domain/news/news_model.dart';
import 'package:new_api_http_flutter/injection.dart';
import 'package:new_api_http_flutter/presentation/widgets/search_widget.dart';

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

class HomePageScaffold extends StatefulWidget {
  @override
  _HomePageScaffoldState createState() => _HomePageScaffoldState();
}

class _HomePageScaffoldState extends State<HomePageScaffold> {
  NewsModel? newsModel;

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
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          state.newsListFailureOrSuccessOption?.fold(() {}, (right) {
            right.fold((l) {}, (r) {
              newsModel = r;
            });
          });
        },
        listenWhen: (previous, current) =>
            previous.newsListFailureOrSuccessOption !=
            current.newsListFailureOrSuccessOption,
        buildWhen: (previous, current) =>
            previous.newsListFailureOrSuccessOption !=
            current.newsListFailureOrSuccessOption,
        builder: (context, state) {
          return Column(
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
          );
        },
      ),
    );
  }
}

class TopSelection extends StatelessWidget {
  final List<String> list;

  const TopSelection({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return TopMenuTiles(
            name: list[index],
            index: index,
          );
        },
      ),
    );
  }
}

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

class NewsItems extends StatefulWidget {
  @override
  _NewsItemsState createState() => _NewsItemsState();
}

class _NewsItemsState extends State<NewsItems> {
  final scrollController = ScrollController();
  List<ArticleModel> list = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsBloc, NewsState>(
      listenWhen: (previous, current) =>
          previous.newsListFailureOrSuccessOption !=
          current.newsListFailureOrSuccessOption,
      buildWhen: (previous, current) =>
          previous.newsListFailureOrSuccessOption !=
          current.newsListFailureOrSuccessOption,
      listener: (context, state) {
        state.newsListFailureOrSuccessOption?.fold(() {}, (right) {
          right.fold((l) {}, (r) {
            list = r.articles;
          });
        });
      },
      builder: (context, state) {
        if (state.isSubmitting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return (list.isNotEmpty)
              ? NotificationListener<ScrollNotification>(
                  onNotification: _handleNotification,
                  child: ListView.builder(
                    controller: scrollController,
                    primary: false,
                    itemCount: list.length,
                    itemBuilder: (context, index) => NewsItemTile(
                      articleModel: list[index],
                    ),
                  ),
                )
              : const Center(
                  child: Text("No data Found"),
                );
        }
      },
    );
  }

  bool _handleNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        scrollController.position.extentAfter == 0) {
      if (context.read<NewsBloc>().state.isEndOfList) {
        //no data to paginate
      } else if (context.read<NewsBloc>().state.isListing) {
        context.read<NewsBloc>().add(const NewsEvent.pageCountEvent());

        context.read<NewsBloc>().add(const NewsEvent.readNewsEvent());
      } else if (context.read<NewsBloc>().state.isSearch) {
        context.read<NewsBloc>().add(const NewsEvent.pageCountEvent());
        context.read<NewsBloc>().add(const NewsEvent.searchQueryChangedEvent());
      } else {
        context.read<NewsBloc>().add(const NewsEvent.pageCountEvent());

        context
            .read<NewsBloc>()
            .add(const NewsEvent.filterNewsBySourcesEvent());
      }
    }
    return false;
  }
}

class NewsItemTile extends StatelessWidget {
  final ArticleModel articleModel;

  NewsItemTile({
    super.key,
    required this.articleModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //todo details page
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Center(
                  child: Image.network(
                    articleModel.urlToImage??"",
                    width: 200,
                    height: 145,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress,) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: Image.network(
                          articleModel.urlToImage??"",
                          width: 200,
                          height: 145,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress,) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: (loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes != 0)
                                    ? (loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                            .toDouble())
                                    : null,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          articleModel.title??"",
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color(0xFF6e6e71),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
