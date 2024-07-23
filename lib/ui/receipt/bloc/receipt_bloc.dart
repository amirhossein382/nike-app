import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/payment_reciept.dart';
import 'package:nike/data/repo/order_repo.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final OrderRepository repository;
  ReceiptBloc({required this.repository}) : super(ReceiptLoadinState()) {
    on<ReceiptEvent>((event, emit) async {
      if (event is ReceiptStartedEvent) {
        emit(ReceiptLoadinState());
        try {
          debugPrint("order id ---->${event.orderId}");
          final response = await repository.getPaymentReciept(event.orderId);
          emit(ReceiptSuccessState(data: response));
        } catch (e) {
          emit(ReceiptErrorState(
              exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
