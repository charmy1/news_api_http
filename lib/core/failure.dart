import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

//
class ServerFailure extends Failure {}

class NoInternetFailure extends Failure {}

class NoDataFailure extends Failure{}
