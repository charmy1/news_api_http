import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:new_api_http_flutter/core/constants.dart';
import 'package:new_api_http_flutter/core/failure.dart';
import 'package:new_api_http_flutter/core/network_info.dart';
import 'package:new_api_http_flutter/domain/news/news_interface.dart';
import 'package:new_api_http_flutter/domain/news/news_model.dart';

@LazySingleton(as: NewsInterface)
class NewsImpl extends NewsInterface {
  final NetworkInfo _networkInfo;
  final http.Client client;
  NewsImpl(this._networkInfo, this.client);

  @override
  Future<Either<Failure,NewsModel>> getAllNewsData({required int page}) async {
    if (await _networkInfo.isConnected) {
      try {
        final data = await getAllNews(page:page);
        if (data.totalResults > 0) {
          return Right(data);
        } else {
          return Left(NoDataFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }



  @override
  Future<Either<Failure, NewsModel>> searchNewsData({required int page,required String query}) async{
    if (await _networkInfo.isConnected) {
      try {
        final data = await searchNews(page:page,search: query);
        if (data.totalResults > 0) {
          return Right(data);
        } else {
          return Left(NoDataFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, NewsModel>> sourcesFilterNewsData({required int page,required String source}) async{
    if (await _networkInfo.isConnected) {
      try {
        final data = await sourcesFilter(page:page,source: source);
        if (data.totalResults > 0) {
          return Right(data);
        } else {
          return Left(NoDataFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }



  //todo
  Future<NewsModel> getAllNews({required int page}) async {
    final response = await client.get(
      Uri.parse("${Constants.url}&page=$page"),
      headers: {
        'Content-Type': 'application/json',
      },
    );


    //print("CODE ${response.statusCode}");
    if (response.statusCode == 200) {

      final result=NewsModel.fromJson(jsonDecode(response.body) as Map<String, dynamic> );
      return result;
    } else {
      throw ServerException();
    }
  }

  Future<NewsModel> searchNews({required int page, required String search}) async {
    final response = await client.get(
      Uri.parse("${Constants.url}&page=$page&q=$search"),
      headers: {
        'Content-Type': 'application/json',
      },
    );


    print("CODE ${response.statusCode}");
    if (response.statusCode == 200) {

      final result=NewsModel.fromJson(jsonDecode(response.body) as Map<String, dynamic> );
      return result;
    } else {
      throw ServerException();
    }
  }

  Future<NewsModel> sourcesFilter({required int page,required String source}) async {
    final response = await client.get(
      Uri.parse("${Constants.url}&page=$page&category=$source"),
      headers: {
        'Content-Type': 'application/json',
      },
    );


    print("CODE ${response.statusCode}");
    if (response.statusCode == 200) {

      final result=NewsModel.fromJson(jsonDecode(response.body) as Map<String, dynamic> );
      return result;
    } else {
      throw ServerException();
    }
  }




}

class ServerException implements Exception {}

