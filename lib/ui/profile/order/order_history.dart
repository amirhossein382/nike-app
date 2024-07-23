import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/order_repo.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/profile/order/bloc/order_history_bloc.dart';
import 'package:nike/ui/utils.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return BlocProvider(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStartedEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("سوابق سفارش"),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccessState) {
              return ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: LightTheme.secondryTextColor),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("شناسه سفارش"),
                                  Text(order.id.toString())
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("مبلغ"),
                                  Text(order.payablePrice.withPriceLabel)
                                ],
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                              height: 132,
                              child: ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: order.products.length,
                                  itemBuilder: (context, index) {
                                    final product = order.products[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else if (state is OrderHistoryInitialState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CupertinoActivityIndicator(
                      color: themeData.colorScheme.primary,
                    ),
                  )
                ],
              );
            } else if (state is OrderHistoryErrorState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Center(child: Text(state.exception.message))],
              );
            } else {
              throw Exception(" unknown state in order history");
            }
          },
        ),
      ),
    );
  }
}
