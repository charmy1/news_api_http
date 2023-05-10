import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:new_api_http_flutter/domain/news/article_model.dart';


part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
 class NewsModel with _$NewsModel {
  @JsonSerializable(explicitToJson: true)
  const factory NewsModel({
    required String status,
    required int totalResults,
    required List<ArticleModel> articles,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

}