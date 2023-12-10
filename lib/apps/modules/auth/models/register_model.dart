class RegisterModel {
  String firstName;
  String otherNames;
  String lastName;
  String email;
  String password;
  String phoneNumber;

  RegisterModel({
    required this.firstName,
    required this.otherNames,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        firstName: json["firstName"],
        otherNames: json["otherNames"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "otherNames": otherNames,
        "lastName": lastName,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
      };
}

class UserDetailsModel {
    String? accessToken;
    String? refreshToken;
    CurrentUser? currentUser;

    UserDetailsModel({
        this.accessToken,
        this.refreshToken,
        this.currentUser,
    });

    factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        currentUser: CurrentUser.fromJson(json["currentUser"]),
    );

    Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "currentUser": currentUser?.toJson(),
    };
}

class CurrentUser {
    String? userId;
    String? userName;
    String? firstName;
    String? lastName;
    String? email;

    CurrentUser({
        this.userId,
        this.userName,
        this.firstName,
        this.lastName,
        this.email,
    });

    factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
        userId: json["userId"],
        userName: json["userName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
    };
}