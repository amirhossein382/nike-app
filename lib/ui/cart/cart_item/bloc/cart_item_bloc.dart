import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/repo/cart_repository.dart';

part 'cart_item_event.dart';
part 'cart_item_state.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  final CartRepository repository;
  CartItemBloc(this.repository) : super(CartItemInitial()) {
    on<CartItemEvent>((event, emit) async {
      if (event is CartItemDeleteButtonClickedEvent) {
        try {
          emit(CartItemDeleteLoadingState());
          await repository.delete(event.cartItemId);
          emit(CartItemDeleteSuccessState());
        } catch (e) {
          CartItemDeleteErrorState(
              exception: AppException(message: e.toString()));
        }
      } else if (event is CartItemPlusButtonClickedEvent) {
        int count = event.cartItemCount;
        int newCount = ++count;
        debugPrint("new count -----------> $newCount");
        try {
          emit(CartItemChangeCountLoadingState());
          await repository.changeCount(event.cartItemId, newCount);
          emit(CartItemChangeCountSuccessState());
        } catch (e) {
          emit(CartItemChangeCountErrorState(
              exception: AppException(message: e.toString())));
        }
      }else if (event is CartItemMinusButtonClickedEvent) {
        int count = event.cartItemCount;
        int newCount = --count;
        debugPrint("new count -----------> $newCount");
        try {
          emit(CartItemChangeCountLoadingState());
          await repository.changeCount(event.cartItemId, newCount);
          emit(CartItemChangeCountSuccessState());
        } catch (e) {
          emit(CartItemChangeCountErrorState(
              exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
