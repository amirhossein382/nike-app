import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;
  CartBloc(this.repository) : super(CartLoadingState()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStartedEvent) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequiredState());
        } else {
          await getAllData(emit, false);
        }
      } else if (event is CartRefreshEvent) {
        await getAllData(emit, event.isRefreshFromSmart);
      }
    });
  }
  Future<void> getAllData(Emitter emit, bool isRefreshFromSmatRefresh) async {
    try {
      if(!isRefreshFromSmatRefresh){
        emit(CartLoadingState());
        }
      
      final CartResponse response = await repository.getAll();
      if (response.cartItems.isEmpty) {
        emit(CartEmptyState());
      } else {
        emit(CartSuccessState(response: response));
      }
    } catch (e) {
      emit(CartErrorState(exception: AppException(message: e.toString())));
    }
  }
}
