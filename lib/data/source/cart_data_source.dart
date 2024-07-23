import 'package:dio/dio.dart';
import 'package:nike/common/validators.dart';
import 'package:nike/data/add_to_cart_response.dart';
import 'package:nike/data/cart_response.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource({required this.httpClient});

  @override
  Future<AddToCartResponse> add(int productId) async {
    final response =
        await httpClient.post('cart/add', data: {"product_id": productId});

    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) async {
    final response = await httpClient.post("cart/changeCount",
        data: {"cart_item_id": cartItemId, "count": count});
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final Response response = await httpClient.get("cart/count");
    validateResponse(response);
    return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId) async {
    final response = await httpClient
        .post("cart/remove", data: {'cart_item_id': cartItemId});
    validateResponse(response);
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get("cart/list");
    validateResponse(response);
    return CartResponse.fromJson(response.data);
  }
}
