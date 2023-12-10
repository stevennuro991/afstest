import 'package:afs_test/helper/service_response.dart';
import 'package:afs_test/utils/logger.dart';


class TokenService {
  static Future<ServiceResponse<dynamic>> accessToken(
      String refreshToken) async {
    return (await ApiService<dynamic>().postCall("/api/identity/access-token?refreshToken=$refreshToken",
        onLog: (res) => logResponse(res),
        getDataFromResponse: (data) => data));
  }

  static Future<ServiceResponse<dynamic>> refreshToken(String userId) async {
    return (await ApiService<dynamic>().postCall(
        "/api/identity/refresh-token?sub=$userId",
        onLog: (res) => logResponse(res),
        getDataFromResponse: (data) => data));
  }
}
