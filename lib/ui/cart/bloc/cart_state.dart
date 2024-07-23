part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartLoadingState extends CartState {}

final class CartErrorState extends CartState {
  final AppException exception;

  const CartErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class CartSuccessState extends CartState {
  final CartResponse response;

  const CartSuccessState({required this.response});

  @override
  List<Object> get props => [response];
}

final class CartAuthRequiredState extends CartState {}

final class CartEmptyState extends CartState {}

