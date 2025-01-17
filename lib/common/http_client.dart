import 'package:dio/dio.dart';
import 'package:nike/data/repo/auth_repo.dart';

final httpClient =
    Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final authInfo = AuthRepository.authValueNotifire.value;
          if (authInfo != null && authInfo.accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
          }

          handler.next(options);
        },
      ));
