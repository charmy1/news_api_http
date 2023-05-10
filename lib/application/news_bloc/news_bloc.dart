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
import 'package:flutter_bloc/flutter_bloc.dart';
part 'news_bloc.freezed.dart';

part 'news_event.dart';

part 'news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsInterface _newsInterface;

  NewsBloc(this._newsInterface) : super(NewsState.initial()) {
    on<ReadNewsEvent>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isListing: true, isSearch: false, isFilter: false));
      final result = await _newsInterface.getAllNewsData(page: state.page);
      emit(state.copyWith(isSubmitting: false, newsListFailureOrSuccessOption: optionOf(result)));
    });

    on<PageCountEvent>((event, emit) {
      final pageCount = state.page;
      emit(state.copyWith(page: pageCount + 1));
    });

    on<PageCountEventReset>((event, emit) {
      emit(state.copyWith(page: 1));
    });

    on<FilterNewsBySourcesEvent>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFilter: true, isSearch: false, isListing: false));
      final result =
      await _newsInterface.sourcesFilterNewsData(page: state.page, source: state.source);
      emit(state.copyWith(isSubmitting: false, newsListFailureOrSuccessOption: optionOf(result)));
    });

    on<SearchQueryChangedEvent>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isSearch: true, isFilter: false, isListing: false));
      final result =
      await _newsInterface.searchNewsData(page: state.page, query: state.searchText);
      emit(state.copyWith(isSubmitting: false, newsListFailureOrSuccessOption: optionOf(result)));
    });

    on<SourceChangedEvent>((event, emit) {
      emit(state.copyWith(isSubmitting: true, source: event.source));
    });

    on<TextChangedEvent>((event, emit) {
      emit(state.copyWith(isSubmitting: true, searchText: event.searchQuery));
    });

    on<ReachedEndOfList>((event, emit) {});
  }

  Stream<Transition<NewsEvent, NewsState>> transformTransitions(
      Stream<Transition<NewsEvent, NewsState>> transitions,
      ) {
    final nonDebounceStream = transitions.where(
          (transition) => transition.event is! SearchQueryChangedEvent,
    );
    final debounceStream = transitions.where(
          (transition) => transition.event is SearchQueryChangedEvent,
    ).debounceTime(const Duration(milliseconds: 300));

    return MergeStream([
      nonDebounceStream,
      debounceStream,
    ]).asyncExpand((transition) => Stream.value(transition));
  }

  @override
  void onTransition(Transition<NewsEvent, NewsState> transition) {
    super.onTransition(transition);

    debugPrint(transition.currentState.page.toString());
    debugPrint(transition.nextState.page.toString());
  }
}
