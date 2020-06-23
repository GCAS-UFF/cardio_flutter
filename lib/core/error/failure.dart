import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  Failure([this.properties = const <dynamic>[]]);
  List<Object> get props => properties;
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NoInternetConnectionFailure extends Failure {}

class PlatformFailure extends Failure {
  final String message;

  PlatformFailure({this.message});

  List<Object> get props => [message];
}

class UserNotCachedFailure extends Failure {}
