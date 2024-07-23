part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

final class ProductListInitialState extends ProductListState {}

final class ProductListLoadingState extends ProductListState {}

final class ProductListErrorState extends ProductListState {
  final AppException exception;

  const ProductListErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class ProductListSuccessState extends ProductListState {
  final List<ProductJson> products;

  const ProductListSuccessState({required this.products});

  @override
  List<Object> get props => [products];
}
