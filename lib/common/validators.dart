import 'package:dio/dio.dart';
import 'package:nike/common/exceptions.dart';

void validateResponse(Response response) {
  if (response.statusCode != 200) {
    throw AppException();
  }
}
