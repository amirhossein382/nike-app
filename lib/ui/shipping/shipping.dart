import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/repo/order_repo.dart';
import 'package:nike/ui/cart/price_info.dart';
import 'package:nike/ui/receipt/receipt.dart';
import 'package:nike/ui/shipping/bloc/shipping_bloc.dart';
import 'package:nike/ui/web_view/web_view.dart';

final _formKey = GlobalKey<FormState>();

class ShippingScreen extends StatelessWidget {
  final int totalPrice;
  final int shippingCost;
  final int payablePrice;
  const ShippingScreen(
      {super.key,
      required this.totalPrice,
      required this.shippingCost,
      required this.payablePrice});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final TextEditingController nameController =
        TextEditingController(text: "امیرحسین");
    final TextEditingController lastNameController =
        TextEditingController(text: "بختیاری");
    final TextEditingController postalCodeController =
        TextEditingController(text: "1234567890");
    final TextEditingController mobileController =
        TextEditingController(text: "09963956051");
    final TextEditingController addressController =
        TextEditingController(text: "آذربایجان شرقی");

    return Scaffold(
      appBar: AppBar(
        titleSpacing: .5,
        title: Text(
          "انتخاب تحویل گیرنده و شیوه پرداخت",
          style: themeData.textTheme.titleLarge?.apply(fontSizeFactor: .9),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocProvider(
            create: (context) {
              final ShippingBloc bloc = ShippingBloc(orderRepository);
              bloc.stream.forEach((state) {
                if (state is ShippingErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.exception.message),
                  ));
                } else if (state is ShippingSuccessState) {
                  if (state.result.bankGatewat.isEmpty) {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                          builder: (context) => PeymentReceiptScreen(
                                orderId: state.result.orderId,
                              )),
                    );
                  } else {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => PaymentWebViewScreen(
                              url: state.result.bankGatewat,
                            )));
                  }
                }
              });
              return bloc;
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "نام",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "لطفا نام خود را وارد کنید";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "نام خانوادگی",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "لطفا نام خانوادگی خود را وارد کنید";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: postalCodeController,
                    decoration: const InputDecoration(
                        labelText: "کد پستی", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "لطفا کد پستی خود را وارد کنید";
                      } else if (value.length != 10) {
                        return "کد پستی باید 10 رقم باشد";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: mobileController,
                    decoration: const InputDecoration(
                        labelText: "شماره تماس", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "لطفا شماره تماس خود را وارد کنید";
                      } else if (value.length != 11) {
                        return "شماره تماس شما معتبر نیست";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                          labelText: "آدرس تحویل گیرنده",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "لطفا آدرس تحویل گیرنده را وارد کنید";
                        } else if (value.length < 20) {
                          return "آدرس تحویل گیرنده باید حداقل 20 کاراکتر باشد";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  PriceInfo(
                    totalPrcie: totalPrice,
                    shippingCost: shippingCost,
                    payablePrice: payablePrice,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  BlocBuilder<ShippingBloc, ShippingState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateButtonClickedEvent(
                                      params: OrderParams(
                                        address: addressController.text,
                                        firstName: nameController.text,
                                        lastName: lastNameController.text,
                                        phoneNumber: mobileController.text,
                                        postalCode: postalCodeController.text,
                                        paymentMethod:
                                            PaymentMethod.cashOnDelivery,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: state is ShippingLoadingState
                                  ? CupertinoActivityIndicator(
                                      color: themeData.colorScheme.primary,
                                    )
                                  : Text(
                                      "پرداخت در محل",
                                      style: themeData.textTheme.titleSmall
                                          ?.apply(
                                              color: themeData
                                                  .colorScheme.primary),
                                    )),
                          const SizedBox(
                            width: 12,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateButtonClickedEvent(
                                      params: OrderParams(
                                        address: addressController.text,
                                        firstName: nameController.text,
                                        lastName: lastNameController.text,
                                        phoneNumber: mobileController.text,
                                        postalCode: postalCodeController.text,
                                        paymentMethod: PaymentMethod.online,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: state is ShippingLoadingState
                                  ? CupertinoActivityIndicator(
                                      color: themeData.colorScheme.primary,
                                    )
                                  : Text(
                                      "پرداخت اینترنتی",
                                      style: themeData.textTheme.titleSmall
                                          ?.apply(
                                              color: themeData
                                                  .colorScheme.surface),
                                    )),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
