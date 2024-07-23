import 'package:dio/dio.dart';
import 'package:nike/common/validators.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/payment_reciept.dart';

abstract class IOrderDataSource {
  Future<OrderResult> create(OrderParams params);
  Future<PaymentRecieptJson> getPaymentReciept(int orderId);
  Future<List<OrderJson>> getOrders();
}

final class OrderDataSource implements IOrderDataSource {
  final Dio httpClient;

  OrderDataSource({required this.httpClient});
  @override
  Future<OrderResult> create(OrderParams params) async {
    final Response response = await httpClient.post(
      'order/submit',
      data: {
        'first_name': params.firstName,
        'last_name': params.lastName,
        'mobile': params.phoneNumber,
        'postal_code': params.postalCode,
        'address': params.address,
        'payment_method': params.paymentMethod == PaymentMethod.online
            ? 'online'
            : 'cash_on_delivery',
      },
    );
    validateResponse(response);
    return OrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentRecieptJson> getPaymentReciept(int orderId) async {
    final Response response =
        await httpClient.get("order/checkout?order_id=$orderId");
    validateResponse(response);
    return PaymentRecieptJson.fromJson(response.data);
  }

  @override
  Future<List<OrderJson>> getOrders() async {
    final response = await httpClient.get("order/list");
    validateResponse(response);
    return (response.data as List).map((e) => OrderJson.fromJson(e)).toList();
  }
}
