import 'package:flutter/material.dart';
import 'package:nike/ui/utils.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo(
      {super.key,
      required this.totalPrcie,
      required this.shippingCost,
      required this.payablePrice});
  final int totalPrcie;
  final int shippingCost;
  final int payablePrice;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 4, top: 16),
          child: Text(
            "جزیًیات خرید",
            style: themeData.textTheme.titleMedium!
                .copyWith(color: Colors.black.withOpacity(.4)),
          ),
        ),
        Card.filled(
          child: Column(
            children: [
              _PriceDetail(
                themeData: themeData,
                title: "مبلغ کل خرید",
                content: RichText(
                  text: TextSpan(
                      text: totalPrcie.seperateByComma,
                      style: themeData.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: ' تومان',
                            style: themeData.textTheme.bodyMedium)
                      ]),
                ),
              ),
              const Divider(
                endIndent: 4,
                indent: 4,
              ),
              _PriceDetail(
                  themeData: themeData,
                  title: "هزینه ارسال",
                  content: Text(
                    shippingCost == 0 ? "رایگان" : shippingCost.toString(),
                    style: themeData.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  )),
              const Divider(
                endIndent: 4,
                indent: 4,
              ),
              _PriceDetail(
                  themeData: themeData,
                  title: "مبلغ قابل پرداخت",
                  content: RichText(
                      text: TextSpan(
                          text: payablePrice.seperateByComma,
                          style: themeData.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                          children: [
                        TextSpan(
                            text: " تومان",
                            style: themeData.textTheme.bodyMedium)
                      ])))
            ],
          ),
        )
      ],
    );
  }
}

class _PriceDetail extends StatelessWidget {
  const _PriceDetail({
    required this.themeData,
    required this.title,
    required this.content,
  });

  final ThemeData themeData;
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: themeData.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          content
        ],
      ),
    );
  }
}
