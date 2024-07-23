import 'package:nike/data/data.dart';

class CartItemEntity {
  final ProductJson product;
  final int id;
  final int count;
  bool deleteButtonLoading=false;

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = ProductJson.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<CartItemEntity> cartItems = [];
    for (var element in jsonArray) {
      cartItems.add(CartItemEntity.fromJson(element));
    }
    return cartItems;
  }
}
