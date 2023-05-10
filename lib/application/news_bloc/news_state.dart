part of 'news_bloc.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState({
    required bool isSubmitting,
    @Default(false) bool isSearch,
    @Default(false) bool isFilter,
    @Default(false) bool isListing,
    @Default(0) int page,
    @Default(false) bool isEndOfList,
    Option<Either<Failure, NewsModel>>? newsListFailureOrSuccessOption,
    @Default("") String searchText,
    @Default("") String source,
  }) = _NewsState;

  factory NewsState.initial() => NewsState(
        isSubmitting: false,
        isSearch: false,
        isFilter: false,
        isListing: true,
        isEndOfList: false,
        source: '',
        page: 1,
        searchText: "",
        newsListFailureOrSuccessOption: none(),
      );
}
