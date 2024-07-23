import 'package:nike/common/http_client.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/payment_reciept.dart';
import 'package:nike/data/source/order_source.dart';

final OrderRepository orderRepository =
    OrderRepository(dataSource: OrderDataSource(httpClient: httpClient));

abstract class IOrderRepository {
  Future<OrderResult> create(OrderParams params);
  Future<PaymentRecieptJson> getPaymentReciept(int orderId);
  Future<List<OrderJson>> getOrders();
}

final class OrderRepository implements IOrderRepository {
  final OrderDataSource dataSource;

  OrderRepository({required this.dataSource});
  @override
  Future<OrderResult> create(OrderParams params) {
    return dataSource.create(params);
  }

  @override
  Future<PaymentRecieptJson> getPaymentReciept(int orderId) {
    return dataSource.getPaymentReciept(orderId);
  }

  @override
  Future<List<OrderJson>> getOrders() {
    return dataSource.getOrders();
  }
}
