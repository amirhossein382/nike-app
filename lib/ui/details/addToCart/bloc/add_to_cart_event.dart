part of 'add_to_cart_bloc.dart';

sealed class AddToCartEvent extends Equatable {
  const AddToCartEvent();

  @override
  List<Object> get props => [];
}

final class AddToCartClickedEvent extends AddToCartEvent {
  final int productId;

  const AddToCartClickedEvent({required this.productId});
  @override
  List<Object> get props => [productId];
}
