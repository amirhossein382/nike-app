part of 'cart_item_bloc.dart';

sealed class CartItemEvent extends Equatable {
  const CartItemEvent();

  @override
  List<Object> get props => [];
}

final class CartItemDeleteButtonClickedEvent extends CartItemEvent {
  final int cartItemId;

  const CartItemDeleteButtonClickedEvent({required this.cartItemId});

  @override
  List<Object> get props => [cartItemId];
}

final class CartItemPlusButtonClickedEvent extends CartItemEvent {
  final int cartItemId;

  final int cartItemCount;

  const CartItemPlusButtonClickedEvent(
      {required this.cartItemId, required this.cartItemCount});

  @override
  List<Object> get props => [cartItemCount];
}

final class CartItemMinusButtonClickedEvent extends CartItemEvent {
  final int cartItemId;
  final int cartItemCount;

  const CartItemMinusButtonClickedEvent(
      {required this.cartItemId, required this.cartItemCount});

  @override
  List<Object> get props => [cartItemCount];
}
