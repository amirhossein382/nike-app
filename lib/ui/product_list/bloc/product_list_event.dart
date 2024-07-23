part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  final int sorted;
  const ProductListEvent(this.sorted);

  @override
  List<Object> get props => [sorted];
}

final class ProductListStartedEvent extends ProductListEvent {
  const ProductListStartedEvent(super.sorted);

  @override
  List<Object> get props => [sorted];
}

final class ProductListChangedSortedEvent extends ProductListEvent {
  const ProductListChangedSortedEvent(super.sorted);

  @override
  List<Object> get props => [sorted];
}
