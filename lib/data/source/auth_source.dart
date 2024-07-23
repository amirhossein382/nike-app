import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike/common/constants.dart';
import 'package:nike/common/validators.dart';
import 'package:nike/data/auth_info.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> refreshToken(String refreshToken);
  Future<AuthInfo> register(String emial, String password);
}

final class AuthDateSource implements IAuthDataSource {
  final Dio httpClient = Dio();
  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient
        .post("http://expertdevelopers.ir/api/v1/auth/token", data: {
      "grant_type": "password",
      "client_id": 2,
      "client_secret": Constants.clientSecret,
      "username": username,
      "password": password
    });
    debugPrint("login status code --------> ${response.statusCode}");
    validateResponse(response);
    return AuthInfo(
        response.data['access_token'], response.data['refresh_token']);
  }

  @override
  Future<AuthInfo> refreshToken(String refreshToken) async {
    final response = await httpClient
        .post("http://expertdevelopers.ir/api/v1/auth/token", data: {
      "grant_type": "refresh_token",
      "client_id": 2,
      "client_secret": Constants.clientSecret,
      "refresh_token": refreshToken
    });

    validateResponse(response);
    return AuthInfo(
        response.data['access_token'], response.data['refresh_token']);
  }

  @override
  Future<AuthInfo> register(String email, String password) async {
    final response = await httpClient.post(
        'http://expertdevelopers.ir/api/v1/user/register',
        data: {'email': email, 'password': password});

    validateResponse(response);
    return login(email, password);
  }
}
