import 'package:flutter/material.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/source/auth_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(dataSource: AuthDateSource());

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> refreshToken();
  Future<void> register(String email, String password);
  Future<void> signOut();
}

final class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authValueNotifire = ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository({required this.dataSource});
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _presistAuthTokens(authInfo);
    loadAuthInfo();
  }

  @override
  Future<void> refreshToken() async {
    final AuthInfo authInfo = await dataSource.refreshToken(
        "def502007e823f92260c72a46d65f05b2493d9f19f00455abd656d1e5819e93032a5a622708fa94cc750c93c39b1b0de7407064cd75904890c2dcfddb4ef3026a7697e0872b90388f112aeb3a1f66a332992619ab5f3940e5727adcd13e821519f787428385c3f180d3fd45eb449de73c275c78008610e37255acdc96807693ea61be5736aae3047504742775d3c2ac633abceeaa45ea52efb4004ed2bdf62b94ebeab3374291ef611855fdcb05771d0ce74d227efbe6120fc773de658bb978fec567e256008585cfbbeead3331a728c394f0fc1a8644dfb663af82aae7eaaf615c6ccdd8b6ffe4e55340d646275ce5b9e503582e75e662c7f6e2345961dae3c426511f5fcf908079b11ea96a341db8bb75a7e205930f1970ecae95fa4b7544eb4fbf6dbdbe51b5f2922fcd91a0c9dc181040c565f89cd7d23506c42d4b2b061156204d6fbef7863019bceb9df18b41083330f6105d13802d393dd4b702d368a7611");
    _presistAuthTokens(authInfo);
  }

  @override
  Future<void> register(String email, String password) async {
    final AuthInfo authInfo = await dataSource.register(email, password);
    _presistAuthTokens(authInfo);
  }

  @override
  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authValueNotifire.value = null;
  }

  Future<void> _presistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';
    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authValueNotifire.value = AuthInfo(accessToken, refreshToken);
    }
  }
}
