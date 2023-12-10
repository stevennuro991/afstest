import 'package:afs_test/apps/modules/auth/models/register_model.dart';
import 'package:hive/hive.dart';

class LocalStorage {
  final wegooBox = Hive.box('afsTest');

  saveUserDetails({required UserDetailsModel userModel}) async {
    await wegooBox.clear();
    await wegooBox.put('firstName', userModel.currentUser?.firstName);
    await wegooBox.put('lastName', userModel.currentUser?.lastName);
    await wegooBox.put('email', userModel.currentUser?.email);
    await wegooBox.put('userId', userModel.currentUser?.userId);
  }

  UserDetailsModel readUserDetails() {
    String? firstName = wegooBox.get('firstName');
    String? lastName = wegooBox.get('lastName');
    String? uid = wegooBox.get('userId');
    String? email = wegooBox.get('email');

    return UserDetailsModel(
      currentUser: CurrentUser(
          firstName: firstName, lastName: lastName, email: email, userId: uid),
    );
  }

  Future logout() async {
    await wegooBox.clear();
  }
}
