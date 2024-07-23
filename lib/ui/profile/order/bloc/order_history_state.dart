part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

final class OrderHistoryInitialState extends OrderHistoryState {}

final class OrderHistorySuccessState extends OrderHistoryState {
  final List<OrderJson> orders;

  const OrderHistorySuccessState({required this.orders});

  @override
  List<Object> get props => [orders];
}

final class OrderHistoryErrorState extends OrderHistoryState {
  final AppException exception;

  const OrderHistoryErrorState({required this.exception});
  @override
  List<Object> get props => [exception];
}
