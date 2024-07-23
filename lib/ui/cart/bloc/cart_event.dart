part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

final class CartStartedEvent extends CartEvent {
  final AuthInfo? authInfo;

  const CartStartedEvent({required this.authInfo});
}

final class CartDeleteButtonClickedEvent extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClickedEvent({required this.cartItemId});

  @override
  List<Object> get props => [cartItemId];
}

final class CartRefreshEvent extends CartEvent {
  final bool isRefreshFromSmart;

  const CartRefreshEvent({required this.isRefreshFromSmart});
}
