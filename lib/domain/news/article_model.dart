
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:new_api_http_flutter/domain/news/source_model.dart';
part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
abstract class ArticleModel with _$ArticleModel {
  @JsonSerializable(explicitToJson: true)
  const factory ArticleModel({
    SourceModel source,
    String author,
    String title,
    String description,
    String url,
    String urlToImage,
    String publishedAt,
    String content,

  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

}