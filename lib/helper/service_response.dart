import 'dart:convert';
import 'package:afs_test/helper/interceptors.dart';
import 'package:afs_test/utils/constants.dart';
import 'package:afs_test/utils/extras.dart';
import 'package:afs_test/utils/logger.dart';
import 'package:afs_test/utils/notifier_state.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

String baseUrl = "http://localhost:5152";

Client get client => InterceptedClient.build(
      interceptors: [AuthorizationInterceptor()],
      retryPolicy: ExpiredTokenRetryPolicy(),
    );

class ServiceResponse<T> {
  late bool status;
  final T? data;
  final String? message;
  final int? statusCode;
  final bool notAuthenticated;

  ServiceResponse(
      {this.data,
      this.message,
      this.statusCode,
      required this.status,
      this.notAuthenticated = false});

  NotifierState<T> toNotifierState() {
    return status
        ? notifyRight<T>(data: data, message: message)
        : notifyError<T>(
            message: message, noAuth: notAuthenticated, statusCode: statusCode);
  }

  @override
  String toString() {
    return 'ServiceResponse{status: $status, data: $data, message: $message, statusCode: $statusCode, notAuthenticated: $notAuthenticated,}';
  }
}

ServiceResponse<T> serveSuccess<T>({required T? data, String? message}) {
  return ServiceResponse<T>(
    status: true,
    message: message,
    data: data,
  );
}

ServiceResponse<T> serveError<T>(
    {required String error,
    T? data,
    int? statusCode,
    bool notAuthenticated = false}) {
  return ServiceResponse<T>(
    status: false,
    message: error,
    data: data,
    statusCode: statusCode,
    notAuthenticated: notAuthenticated,
  );
}

// CancellationToken? cancellationToken;

class ApiService<T> {
  Future<ServiceResponse<T>> getCall(
    String? urlSuffix, {
    required T Function(dynamic) getDataFromResponse,
    required Function(http.Response) onLog,
    String? mainUrl,
    bool isFormData = false,
    bool hasAuth = true,
  }) async {
    String url = mainUrl ?? "$baseUrl$urlSuffix";
    logPrint(url);
    try {
      http.Response response =
          await client.get(Uri.parse(url)).timeout(requestDuration);
      onLog(response);
      if (response.statusCode >= 300 && response.statusCode <= 520) {
        throw response;
      } else {
        var responseBody = jsonDecode(response.body);
        return serveSuccess<T>(
            data: getDataFromResponse(responseBody),
            message: responseBody?["message"] ?? "Successful");
      }
    } catch (error, stack) {
      return processServiceError<T>(error, stack);
    }
  }

  Future<ServiceResponse<T>> postCall(
    String? urlSuffix, {
    Map<String, dynamic>? body,
    required T Function(dynamic) getDataFromResponse,
    required Function(http.Response) onLog,
    String? mainUrl,
    bool hasAuth = true,
  }) async {
    String url = mainUrl ?? "$baseUrl$urlSuffix";
    logPrint("$url\n$body");
    try {
      logPrint("This is it ${Uri.parse(url)}");
      http.Response response = await client
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
          )
          .timeout(requestDuration);
      onLog(response);
      if (response.statusCode >= 300 && response.statusCode <= 520) {
        throw response;
      } else {
        var responseBody = jsonDecode(response.body);
        return serveSuccess<T>(
            data: getDataFromResponse(responseBody),
            message: responseBody?["message"] ?? "Successful");
      }
    } catch (error, stack) {
      return processServiceError<T>(error, stack);
    }
  }
}
