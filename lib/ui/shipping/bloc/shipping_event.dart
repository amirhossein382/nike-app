part of 'shipping_bloc.dart';

sealed class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object> get props => [];
}

final class ShippingCreateButtonClickedEvent extends ShippingEvent {
  final OrderParams params;

  const ShippingCreateButtonClickedEvent({required this.params});

  @override
  List<Object> get props => [params];
}
