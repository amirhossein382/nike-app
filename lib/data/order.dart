import 'package:nike/data/data.dart';

class OrderResult {
  final int orderId;
  final String bankGatewat;

  OrderResult({required this.orderId, required this.bankGatewat});
  OrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewat = json['bank_gateway_url'];
}

class OrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  OrderParams(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.postalCode,
      required this.address,
      required this.paymentMethod});
}

enum PaymentMethod { online, cashOnDelivery }

class OrderJson {
  final int id;
  final int payablePrice;
  final List<ProductJson> products;

  OrderJson(
      {required this.id, required this.payablePrice, required this.products});

  OrderJson.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        products = (json['order_items'] as List)
            .map((e) => ProductJson.fromJson(e['product']))
            .toList();
}
