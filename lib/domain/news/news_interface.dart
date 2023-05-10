import 'package:dartz/dartz.dart';
import 'package:new_api_http_flutter/core/failure.dart';
import 'package:new_api_http_flutter/domain/news/news_model.dart';


abstract class NewsInterface{
  Future<Either<Failure,NewsModel>> getAllNewsData({required int page});
  Future<Either<Failure,NewsModel>> searchNewsData({required int page,required String query});
  Future<Either<Failure,NewsModel>> sourcesFilterNewsData({required int page,required String source});
  //todo sort



}