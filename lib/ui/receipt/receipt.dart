import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/order_repo.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/receipt/bloc/receipt_bloc.dart';
import 'package:nike/ui/utils.dart';

class PeymentReceiptScreen extends StatelessWidget {
  final int orderId;
  const PeymentReceiptScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return BlocProvider<ReceiptBloc>(
      create: (context) {
        final bloc = ReceiptBloc(repository: orderRepository);
        bloc.add(ReceiptStartedEvent(orderId: orderId));
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("رسید پرداخت"),
          centerTitle: false,
        ),
        body: BlocBuilder<ReceiptBloc, ReceiptState>(
          builder: (context, state) {
            if (state is ReceiptErrorState) {
              return Center(
                child: Text(
                  state.exception.message,
                  style: themeData.textTheme.bodyLarge,
                ),
              );
            } else if (state is ReceiptLoadinState) {
              return Center(
                  child: CupertinoActivityIndicator(
                color: themeData.colorScheme.primary,
              ));
            } else if (state is ReceiptSuccessState) {
              return Column(
                children: [
                  Card.outlined(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        side: BorderSide(color: LightTheme.secondryTextColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 12),
                            child: Text(
                              state.data.perchaseSuccess ?"پرداخت موفق" : "پرداخت ناموفق",
                              style: themeData.textTheme.titleLarge?.apply(
                                  fontSizeFactor: .8,
                                  color: themeData.colorScheme.primary),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "وضعیت سفارش",
                                style: themeData.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: LightTheme.secondryTextColor),
                              ),
                              Text(
                                state.data.paymentStatus,
                                style: themeData.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Divider(
                            endIndent: 8,
                            indent: 8,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "مبلغ",
                                style: themeData.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: LightTheme.secondryTextColor),
                              ),
                              Text(
                                state.data.payablePrice.withPriceLabel,
                                style: themeData.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text(
                        "بازگشت به صفحه اصلی",
                        style: themeData.textTheme.titleSmall
                            ?.apply(color: themeData.colorScheme.surface),
                      ))
                ],
              );
            } else {
              throw Exception("unknown exception");
            }
          },
        ),
      ),
    );
  }
}
