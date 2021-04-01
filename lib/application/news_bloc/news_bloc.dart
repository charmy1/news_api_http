import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:new_api_http_flutter/core/failure.dart';
import 'package:new_api_http_flutter/domain/news/news_interface.dart';
import 'package:new_api_http_flutter/domain/news/news_model.dart';
import 'package:rxdart/rxdart.dart';

part 'news_bloc.freezed.dart';

part 'news_event.dart';

part 'news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsInterface _newsInterface;

  NewsBloc(this._newsInterface) : super(NewsState.initial());

  @override
  Stream<Transition<NewsEvent, NewsState>> transformEvents(
    Stream<NewsEvent> events,
    TransitionFunction<NewsEvent, NewsState> transitionFn,
  ) {
    final nonDebounceStream =
        events.where((event) => event is! SearchQueryChangedEvent);
    final debounceStream = events
        .where((event) => event is SearchQueryChangedEvent)
        .debounceTime(
            const Duration(milliseconds: 300)); // change debounce time

    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    yield* event.map(
        readNewsEvent: (e) async* {
          yield state.copyWith(isSubmitting: true,isListing:true,isSearch:false,isFilter:false);
          final result =
              await _newsInterface.getAllNewsData(page: state.page); //todo
          yield state.copyWith(
              isSubmitting: false,
              newsListFailureOrSuccessOption: optionOf(result));
        },
        pageCountEvent: (e) async* {
          int pageCount = state.page;
          print("Page count event ");
          print(state.page);
          print(pageCount++);
          yield state.copyWith(page: pageCount++);
        },
        pageCountEventReset: (e) async* {
          yield state.copyWith(page: 1);
        },
        filterNewsBySourcesEvent: (e) async* {
          yield state.copyWith(isSubmitting: true,isFilter:true,isSearch:false,isListing:false);
          final result = await _newsInterface.sourcesFilterNewsData(
              page: state.page, source: state.source); //todo
          yield state.copyWith(
              isSubmitting: false,
              newsListFailureOrSuccessOption: optionOf(result));
        },
        searchQueryChangedEvent: (e) async* {
          yield state.copyWith(isSubmitting: true,isSearch:true,isFilter:false,isListing:false);
          final result = await _newsInterface.searchNewsData(
              page: state.page, query: state.searchText); //todo
          yield state.copyWith(
              isSubmitting: false,
              newsListFailureOrSuccessOption: optionOf(result));
        },
        sourceChangedEvent: (e) async* {
          yield state.copyWith(isSubmitting: true, source: e.source);
        },
        textChangedEvent: (e) async* {
          yield state.copyWith(isSubmitting: true, searchText: e.searchQuery);
        },
        reachedEndOfList: (e) async* {});
  }

  @override
  void onTransition(Transition<NewsEvent, NewsState> transition) {
    super.onTransition(transition);

    debugPrint(transition.currentState.page.toString());
    debugPrint(transition.nextState.page.toString());
  }
}
