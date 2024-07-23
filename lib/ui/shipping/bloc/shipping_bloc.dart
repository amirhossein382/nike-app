import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/repo/order_repo.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final OrderRepository orderRepository;

  ShippingBloc(this.orderRepository) : super(ShippingInitialState()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateButtonClickedEvent) {
        emit(ShippingLoadingState());
        try {
          final response = await orderRepository.create(event.params);
          emit(ShippingSuccessState(result: response));
        } catch (e) {
          emit(ShippingErrorState(
              exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
