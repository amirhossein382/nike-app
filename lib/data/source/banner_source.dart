import 'package:dio/dio.dart';
import 'package:nike/common/validators.dart';
import 'package:nike/data/data.dart';

abstract class IBannerDataSource {
  Future<List<BannerJson>> getAll();
}

class BannerDataSource implements IBannerDataSource {
  final Dio httpClient = Dio();

  @override
  Future<List<BannerJson>> getAll() async {
    final Response response =
        await httpClient.get("http://expertdevelopers.ir/api/v1/banner/slider");
    validateResponse(response);
    final List<BannerJson> banners = [];
    for (var element in (response.data as List)) {
      banners.add(BannerJson.fromJson(element));
    }
    return banners;
  }
}
