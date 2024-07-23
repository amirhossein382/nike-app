part of 'shipping_bloc.dart';

sealed class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

final class ShippingInitialState extends ShippingState {}

final class ShippingLoadingState extends ShippingState {}

final class ShippingErrorState extends ShippingState {
  final AppException exception;

  const ShippingErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class ShippingSuccessState extends ShippingState {
  final OrderResult result;

  const ShippingSuccessState({required this.result});

  @override
  List<Object> get props => [result];
}
