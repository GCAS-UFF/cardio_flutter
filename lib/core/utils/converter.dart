import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/resources/strings.dart';

class Converter {
  static String convertFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return Strings.message_server_failure;
    } else if (failure is NoInternetConnectionFailure) {
      return Strings.message_no_internet_connection;
    } else if (failure is CacheFailure) {
      return Strings.message_cache_failure;
    } else {
      return Strings.unexpected_error;
    }
  }
}
