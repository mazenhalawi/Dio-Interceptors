import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RequestRetrier {
  final Dio dio;
  final DataConnectionChecker connChecker;

  RequestRetrier({
    @required this.dio,
    @required this.connChecker,
  });

  Future retryRequest(RequestOptions reqOptions) async {
    Completer completer = Completer();
    StreamSubscription subscription;

    subscription = connChecker.onStatusChange.listen((status) {
      if (status == DataConnectionStatus.connected) {
        subscription.cancel();
        final response = dio.request(
          reqOptions.path,
          cancelToken: reqOptions.cancelToken,
          data: reqOptions.data,
          onReceiveProgress: reqOptions.onReceiveProgress,
          onSendProgress: reqOptions.onSendProgress,
          queryParameters: reqOptions.queryParameters,
          options: reqOptions,
        );
        completer.complete(response);
      }
    });

    return completer.future;
  }
}
