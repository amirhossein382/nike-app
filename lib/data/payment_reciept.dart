final class PaymentRecieptJson {
  final bool perchaseSuccess;
  final int payablePrice;
  final String paymentStatus;

  PaymentRecieptJson.fromJson(Map<String, dynamic> json)
      : perchaseSuccess = json['purchase_success'],
        payablePrice = json['payable_price'],
        paymentStatus = json['payment_status'];
}
