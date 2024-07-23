part of 'receipt_bloc.dart';

sealed class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object> get props => [];
}

final class ReceiptLoadinState extends ReceiptState {}

final class ReceiptSuccessState extends ReceiptState {
  final PaymentRecieptJson data;

  const ReceiptSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

final class ReceiptErrorState extends ReceiptState {
  final AppException exception;

  const ReceiptErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}
