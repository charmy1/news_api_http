import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_api_http_flutter/domain/news/article_model.dart';

import '../../../application/news_bloc/news_bloc.dart';

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
      (previous.newsListFailureOrSuccessOption !=
          current.newsListFailureOrSuccessOption)||(previous.isSubmitting!=current.isSubmitting),
      listener: (context, state) {
        state.newsListFailureOrSuccessOption?.fold(() {}, (right) {
          right.fold((l) {}, (r) {
            if (list.isEmpty) {
              list = r.articles;
            } else {
              if (r.articles.isNotEmpty) {
                if (state.page == 0) {
                  list = r.articles;
                } else {
                  list = [...list, ...r.articles];
                }
              }
            }
          });
        });
      },
      builder: (context, state) {
        if (state.isSubmitting &&list.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return (list.isNotEmpty)
              ? NotificationListener<ScrollNotification>(
            onNotification: _handleNotification,
            child: Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  primary: false,
                  itemCount: list.length,
                  itemBuilder: (context, index) => NewsItemTile(
                    articleModel: list[index],
                  ),
                ),
                (state.isSubmitting)?Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(color:Colors.white,height:100,child: const Center(
                    child: const CircularProgressIndicator(color: Colors.black),
                  )),
                ): const SizedBox(height: 0,),
              ],
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
                    articleModel.urlToImage ??
                        "https://picsum.photos/250?image=9",
                    width: 200,
                    height: 145,
                    fit: BoxFit.cover,
                    loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                        ) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: Image.network(
                          articleModel.urlToImage ??
                              "https://picsum.photos/250?image=9",
                          width: 200,
                          height: 145,
                          fit: BoxFit.cover,
                          loadingBuilder: (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                              ) {
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
                          articleModel.title ?? "",
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
