import 'package:dio/dio.dart';
import 'package:nike/common/validators.dart';
import 'package:nike/data/data.dart';

abstract class IProductDataSource {
  Future<List<ProductJson>> getAll(int sort);
  Future<List<ProductJson>> search(String search);
}

class ProductDataSource implements IProductDataSource {
  final Dio httpClient = Dio();

  @override
  Future<List<ProductJson>> getAll(int sort) async {
    final response = await httpClient.get("http://expertdevelopers.ir/api/v1/product/list?sort=$sort");
    validateResponse(response);
    final List<ProductJson> products = [];
    for (var element in (response.data as List)) {
      products.add(ProductJson.fromJson(element));
    }
    return products;
  }

  @override
  Future<List<ProductJson>> search(String search) async {
    final response = await httpClient.get("http://expertdevelopers.ir/api/v1/product/search?q=$search");
    validateResponse(response);
    final List<ProductJson> products = [];
    for (var element in (response.data as List)) {
      products.add(ProductJson.fromJson(element));
    }
    return products;
  }
}

