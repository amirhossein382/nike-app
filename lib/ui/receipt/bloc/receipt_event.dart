part of 'receipt_bloc.dart';

sealed class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

final class ReceiptStartedEvent extends ReceiptEvent {
  final int orderId;

  const ReceiptStartedEvent({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
