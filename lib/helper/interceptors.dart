import 'package:afs_test/apps/modules/auth/services/token_service.dart';
import 'package:afs_test/utils/constants.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (response.statusCode == 500) {
      try {
        final pref = await SharedPreferences.getInstance();
        String token = pref.getString(LocalStorageKeys.refreshToken).toString();
        await TokenService.accessToken(token);
        return true;
      } catch (e) {
        // Logger().d(e);
      }
    }

    return false;
  }

  @override
  int get maxRetryAttempts => 3;
}

class AuthorizationInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final cache = await SharedPreferences.getInstance();
    Map<String, String> generalHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    if (cache.getString(LocalStorageKeys.accessToken) == null) {
      final updatedRequest = request.copyWith(headers: generalHeaders);
      return updatedRequest;
    }

    Map<String, String> updatedHeaders = Map.from(request.headers);

    updatedHeaders.addAll({
      ...generalHeaders,
      "Authorization": "Bearer ${cache.getString(LocalStorageKeys.accessToken)}"
    });
    final updatedRequest = request.copyWith(headers: updatedHeaders);

    return updatedRequest;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async =>
      response;

  @override
  Future<bool> shouldInterceptRequest() {
    return Future.value(true);
  }

  @override
  Future<bool> shouldInterceptResponse() {
    return Future.value(false);
  }
}
