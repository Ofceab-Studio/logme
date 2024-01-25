import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

import '../../error/error.dart';
import '../../formatters/log_message.dart';
import '../sender.dart';

typedef SendEndpointFunc = Future<Response> Function(LogMessage message);

abstract class CustomSender implements Sender {
  /// This method defines where and how send logs through HTTP
  Future<Response> sendEndpoint(
      LogMessage message, SendEndpointFunc sendEndpointFunc);
}

class GenericSender implements CustomSender {
  final SendEndpointFunc sendFunc;

  GenericSender(this.sendFunc);
  @override
  Future<Either<LogError, void>> send(LogMessage message) {
    return LogError.tryCatch(() => sendEndpoint(message, sendFunc));
  }

  @override
  Future<Response> sendEndpoint(
      LogMessage message, SendEndpointFunc sendEndpointFunc) {
    return sendEndpointFunc(message);
  }
}