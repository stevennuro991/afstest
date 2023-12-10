import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:afs_test/helper/service_response.dart';
import 'package:afs_test/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiHeaders {
  // static Map<String, String> headersNoAuth() => {
  //       HttpHeaders.contentTypeHeader: "application/json",
  //       // HttpHeaders.connectionHeader: "keep-alive",
  //     };

  // static Map<String, String> headersSessionAuth() {
  //   return {
  //     HttpHeaders.contentTypeHeader: "application/json",
  //     HttpHeaders.connectionHeader: "keep-alive",
  //     // HttpHeaders.authorizationHeader: "Bearer ${userSession?.token}"
  //   };
  // }

  // static Map<String, String> getHeadersFromRequest(
  //     {bool isFormData = false, bool hasAuth = true}) {
  //   if (hasAuth) {
  //     logPrint(headersSessionAuth());
  //     return headersSessionAuth();
  //   } else {
  //     return headersNoAuth();
  //   }
  // }
}

ServiceResponse<T> processServiceError<T>(error, [StackTrace? stack]) {
  logPrint("$error\n$stack");
  if (error is http.Response) {
    return serveError<T>(
      error: jsonDecode(error.body)["title"],
      statusCode: error.statusCode,
      notAuthenticated: error.statusCode == 401 ? true : false,
    );
  } else if (error is http.StreamedResponse) {
    return serveError<T>(
      error: error.reasonPhrase ?? "Success",
      statusCode: error.statusCode,
      notAuthenticated: error.statusCode == 401 ? true : false,
    );
  } else if (error is Exception) {
    return serveError<T>(error: handleException(error));
  } else {
    return serveError<T>(error: error.toString());
  }
}

String handleException(Exception e) {
  if (e is SocketException) {
    logSocketException(e);
    if (e.message.contains("Failed host lookup")) {
      return "Something went wrong, please try again later";
    }
    return "Request failed, please try again";
  } else if (e is TimeoutException) {
    logTimeoutException(e);
    return "Request timed out, please try again";
  } else if (e is FormatException || e is ClientException) {
    logPrint(e);
    return "Something went wrong, please try again";
  } else {
    return e.toString();
  }
}
