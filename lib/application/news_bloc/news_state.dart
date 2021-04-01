part of 'news_bloc.dart';

@freezed
abstract class NewsState with _$NewsState{

  const factory NewsState({

    @required bool isSubmitting,
    bool isSearch,
    bool isFilter,
    bool isListing,
    int page,
    bool isEndOfList,
    Option<Either<Failure, NewsModel>>
    newsListFailureOrSuccessOption,
    String searchText,
    String source,

  }) = _NewsState;

  factory NewsState.initial() => NewsState(
      isSubmitting: false,
      isSearch:false,
      isFilter:false,
      isListing:true,
      isEndOfList: false,
      source:'',
      page:1,
      searchText:"",
      newsListFailureOrSuccessOption:none(),);
}


