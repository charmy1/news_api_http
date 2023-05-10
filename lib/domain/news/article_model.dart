
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:new_api_http_flutter/domain/news/source_model.dart';
part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
 class ArticleModel with _$ArticleModel {
  @JsonSerializable(explicitToJson: true)
  const factory ArticleModel({
    required SourceModel? source,
    required String? author,
    required String? title,
    required String? description,
    required String? url,
    required String? urlToImage,
    required String? publishedAt,
    required String? content,

  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

}