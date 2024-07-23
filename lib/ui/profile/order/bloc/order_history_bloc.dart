import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/repo/order_repo.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderRepository orderRepository;
  OrderHistoryBloc(this.orderRepository) : super(OrderHistoryInitialState()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStartedEvent) {
        emit(OrderHistoryInitialState());
        try {
          final response = await orderRepository.getOrders();
          emit(OrderHistorySuccessState(orders: response));
        } catch (e) {
          emit(OrderHistoryErrorState(
              exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
