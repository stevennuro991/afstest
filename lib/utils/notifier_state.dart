import 'package:afs_test/utils/flushbar.dart';
import 'package:flutter/material.dart';

enum NotifierStatus { loading, idle, done, error }

class NotifierState<T> {
  final T? data;
  final NotifierStatus status;
  final int? statusCode;
  final String? message;
  final bool noAuth;

  const NotifierState({
    this.data,
    this.status = NotifierStatus.idle,
    this.statusCode,
    this.message,
    this.noAuth = false,
  });

  Widget when({
    required Widget Function(T? data) done,
    Widget? Function(int? statusCode)? error,
    Widget? Function(T? data)? loading,
    Widget? Function()? idle,
  }) {
    // late Widget? res;
    switch (status) {
      case NotifierStatus.loading:
        {
          // res = done(data);
          if (loading != null) {
            return loading(data)!;
          }
          return done(data);
        }
      case NotifierStatus.idle:
        {
          // res = done(data);
          if (idle != null) {
            return idle()!;
          } else {
            return done(data);
          }
        }
      case NotifierStatus.done:
        {
          return done(data);
        }
      case NotifierStatus.error:
        {
          // res = done(data);
          if (error != null) {
            return error(statusCode)!;
          } else {
            return done(data);
          }
        }
    }
  }

  @override
  String toString() {
    return 'NotifierState{data: $data, status: $status, statusCode: $statusCode, message: $message, noAuth: $noAuth}';
  }

  map(Function(dynamic bank) param0) {}
}

NotifierState<T> notifyRight<T>({required T? data, String? message}) {
  return NotifierState<T>(
    status: NotifierStatus.done,
    message: message,
    data: data,
  );
}

NotifierState<T> notifyError<T>(
    {String? message, int? statusCode, bool noAuth = false}) {
  return NotifierState<T>(
    status: NotifierStatus.error,
    message: message,
    statusCode: statusCode,
    noAuth: noAuth,
  );
}

NotifierState<T> notifyLoading<T>([T? data]) {
  return NotifierState(status: NotifierStatus.loading, data: data);
}

NotifierState<T> notifyIdle<T>() {
  return const NotifierState(
    status: NotifierStatus.idle,
  );
}

class ProcessProvider<T> {
  static void runError<T>(
    NotifierState<T> data, {
    Function(int?)? onErrorCallBack,
    bool showErrorPop = false,
    bool showErrorBar = false,
    bool checkAuthentication = true,
  }) {
    if (onErrorCallBack != null) onErrorCallBack(data.statusCode);
    if (data.noAuth && checkAuthentication) {
      // return ResponseHandler.restartApplication(data.message);
    }
    // if (showErrorPop) showErrorDialog(subtitle: data.message);
    if (showErrorBar) showErrorFlush(data.message);
  }

  static void run<T>(
    NotifierState<T> data, {
    Function(T?)? doneCB,
    Function(int?)? errorCB,
    bool showSuccessPop = false,
    bool showErrorPop = true,
    bool showSuccessBar = false,
    bool showErrorBar = false,
    bool checkAuthentication = true,
  }) {
    if (data.status == NotifierStatus.done) {
      if (doneCB != null) doneCB(data.data);
      // if (showSuccessPop) showSuccessDialog(subtitle: data.message);
      if (showSuccessBar) showSuccessFlush(data.message);
    } else if (data.status == NotifierStatus.error) {
      runError(data,
          onErrorCallBack: errorCB,
          showErrorPop: showErrorPop,
          showErrorBar: showErrorBar,
          checkAuthentication: checkAuthentication);
    }
  }
}
