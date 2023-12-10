class TokenModel {
    String accessToken;
    String refreshToken;

    TokenModel({
        required this.accessToken,
        required this.refreshToken,
    });

    factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
    );

    Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
    };
}
