part of 'news_bloc.dart';

@freezed
 class NewsEvent with _$NewsEvent {
  const factory NewsEvent.readNewsEvent() = ReadNewsEvent;
  const factory NewsEvent.filterNewsBySourcesEvent() = FilterNewsBySourcesEvent;
  const factory NewsEvent.searchQueryChangedEvent() =
      SearchQueryChangedEvent;

  const factory NewsEvent.reachedEndOfList() = ReachedEndOfList;

  const factory NewsEvent.textChangedEvent({required String searchQuery }) = TextChangedEvent;

  const factory NewsEvent.sourceChangedEvent({required String source}) = SourceChangedEvent;
  const factory NewsEvent.pageCountEvent() = PageCountEvent;
  const factory NewsEvent.pageCountEventReset() = PageCountEventReset;



}
