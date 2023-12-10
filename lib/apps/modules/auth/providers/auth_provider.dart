import 'package:afs_test/apps/modules/auth/models/register_model.dart';
import 'package:afs_test/apps/modules/auth/models/token_model.dart';
import 'package:afs_test/apps/modules/auth/services/auth_service.dart';
import 'package:afs_test/utils/notifier_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerUserProvider =
    StateNotifierProvider<RegisterUserNotifier, NotifierState<dynamic>>(
        (ref) => RegisterUserNotifier());

class RegisterUserNotifier extends StateNotifier<NotifierState<dynamic>> {
  RegisterUserNotifier() : super(notifyIdle());

  void creaateRegister(RegisterModel model,
      {required Function(dynamic) then}) async {
    state = notifyLoading();
    state = await AuthService.registerUser(model);

    ProcessProvider.run<dynamic>(state,
        showSuccessBar: true,
        showErrorPop: false,
        showErrorBar: true,
        doneCB: then);
  }
}


final userDetailsProvider =
    StateNotifierProvider<UserDetailsNotifier, UserDetailsModel>((ref) {
  return UserDetailsNotifier();
});


class UserDetailsNotifier extends StateNotifier<UserDetailsModel> {
  UserDetailsNotifier() : super(UserDetailsModel());

  void updateUserDetails(UserDetailsModel updatedDetails) {
    state = updatedDetails;
  }
}

final loginUserProvider =
    StateNotifierProvider<LoginUserNotifier, NotifierState<UserDetailsModel>>(
        (ref) => LoginUserNotifier());

class LoginUserNotifier extends StateNotifier<NotifierState<UserDetailsModel>> {
  LoginUserNotifier() : super(notifyIdle());

  void loginUser(String email, String password,{required Function(UserDetailsModel?) then}) async {
    state = notifyLoading();
    state = await AuthService.loginUser(email, password);

    ProcessProvider.run<UserDetailsModel>(state,
        showSuccessBar: true,
        showErrorPop: false,
        showErrorBar: true,
        doneCB: then);
  }
}
