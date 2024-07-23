part of 'add_to_cart_bloc.dart';

sealed class AddToCartState extends Equatable {
  const AddToCartState();

  @override
  List<Object> get props => [];
}

final class AddToCartInitialState extends AddToCartState {}

final class AddToCartLoadingState extends AddToCartState {}

final class AddToCartErrorState extends AddToCartState {
  final AppException exception;

  const AddToCartErrorState({required this.exception});
}

final class AddToCartSuccessState extends AddToCartState {}
