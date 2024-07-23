part of 'cart_item_bloc.dart';

sealed class CartItemState extends Equatable {
  const CartItemState();

  @override
  List<Object> get props => [];
}

final class CartItemInitial extends CartItemState {}

final class CartItemDeleteSuccessState extends CartItemState {}

final class CartItemDeleteLoadingState extends CartItemState {}

final class CartItemDeleteErrorState extends CartItemState {
  final AppException exception;

  const CartItemDeleteErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class CartItemChangeCountSuccessState extends CartItemState {}

final class CartItemChangeCountErrorState extends CartItemState {
  final AppException exception;

  const CartItemChangeCountErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class CartItemChangeCountLoadingState extends CartItemState {}
