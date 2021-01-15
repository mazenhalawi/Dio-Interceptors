import 'dart:async';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dio_proj/request_retrier.dart';

class RetryRequestInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    if (err.type == DioErrorType.DEFAULT &&
        err.error != null &&
        err.error is SocketException) {
      final reqRetrier =
          RequestRetrier(dio: Dio(), connChecker: DataConnectionChecker());
      return reqRetrier.retryRequest(err.request);
    }

    return Future.value(err);
  }
}
