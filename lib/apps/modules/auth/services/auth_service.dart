import 'package:afs_test/apps/modules/auth/models/register_model.dart';
import 'package:afs_test/helper/service_response.dart';
import 'package:afs_test/utils/logger.dart';
import 'package:afs_test/utils/notifier_state.dart';

class AuthService {
  static Future<NotifierState<dynamic>> registerUser(
      RegisterModel model) async {
    return (await ApiService<dynamic>().postCall("/api/identity/signup",
            body: model.toJson(),
            onLog: (res) => logResponse(res),
            getDataFromResponse: (data) => data))
        .toNotifierState();
  }

  static Future<NotifierState<UserDetailsModel>> loginUser(
      String emailAddress, String password) async {
    return (await ApiService<UserDetailsModel>().postCall(
            "/api/identity/signin",
            body: {
              "email": emailAddress,
              "password": password,
              "rememberMe": true
            },
            onLog: (res) => logResponse(res),
            getDataFromResponse: (data) => UserDetailsModel.fromJson(data)))
        .toNotifierState();
  }
}
