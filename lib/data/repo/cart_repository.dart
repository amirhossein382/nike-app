import 'package:flutter/cupertino.dart';
import 'package:nike/common/http_client.dart';
import 'package:nike/data/add_to_cart_response.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/source/cart_data_source.dart';

final cartRepository =
    CartRepository(CartRemoteDataSource(httpClient: httpClient));

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  static ValueNotifier cartValueNotifire = ValueNotifier(null);
  static ValueNotifier<int> cartItemCountNotifire = ValueNotifier(0);
  final ICartDataSource dataSource;

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) {
    return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    cartItemCountNotifire.value = count;
    return count;
  }

  @override
  Future<void> delete(int cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
