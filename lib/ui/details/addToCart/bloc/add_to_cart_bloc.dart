import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/repo/cart_repository.dart';

part 'add_to_cart_event.dart';
part 'add_to_cart_state.dart';

class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  AddToCartBloc() : super(AddToCartInitialState()) {
    on<AddToCartEvent>((event, emit) async {
      if (event is AddToCartClickedEvent) {
        try {
          emit(AddToCartLoadingState());
          final response = await cartRepository.add(event.productId);
          debugPrint("add to cart response ------->${response.count}");
          emit(AddToCartSuccessState());
        } catch (e) {
          emit(AddToCartErrorState(
              exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
