import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/ui/shipping/shipping.dart';
import 'package:nike/ui/widgets/emtpy_state.dart';
import 'package:nike/data/repo/auth_repo.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/cart/bloc/cart_bloc.dart';
import 'package:nike/ui/cart/cart_item/cart_item.dart';
import 'package:nike/ui/cart/price_info.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc cartBloc =CartBloc(cartRepository); 
  @override
  void initState() {
    CartRepository.cartValueNotifire.addListener(() {
      if (CartRepository.cartValueNotifire.value != null) {
        cartBloc.add(const CartRefreshEvent(isRefreshFromSmart: false));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    cartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final RefreshController refreshController = RefreshController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<CartBloc>(
        create: (context) {
          cartBloc.add(CartStartedEvent(
              authInfo: AuthRepository.authValueNotifire.value));
          cartBloc.stream.forEach((state) {
            if (refreshController.isRefresh) {
              if (state is CartSuccessState) {
                refreshController.refreshCompleted();
              }
            }
          });

          return cartBloc;
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState) {
              return Center(
                child: CupertinoActivityIndicator(
                  color: themeData.colorScheme.primary,
                ),
              );
            } else if (state is CartErrorState) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is CartEmptyState) {
              return const EmptyState(
                  imagePath: 'assets/img/empty_cart.svg',
                  text: "سبد خرید شما خالی است",
                  callToAction: SizedBox());
            } else if (state is CartSuccessState) {
              return Scaffold(
                backgroundColor: Colors.black.withOpacity(0.05),
                appBar: AppBar(
                  title: Text(
                    "سبد خرید",
                    style: themeData.textTheme.titleLarge,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: SizedBox(
                    width: MediaQuery.of(context).size.width * .9,
                    child: FloatingActionButton.extended(
                        backgroundColor: themeData.colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26)),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => ShippingScreen(
                                    totalPrice: state.response.totalPrice,
                                    payablePrice: state.response.payablePrice,
                                    shippingCost: state.response.shippingCost,
                                  )));
                        },
                        label: Text(
                          "پرداخت",
                          style: themeData.textTheme.titleSmall!
                              .apply(color: themeData.colorScheme.surface),
                        ))),
                body: SmartRefresher(
                  controller: refreshController,
                  header: const ClassicHeader(
                    refreshStyle: RefreshStyle.Follow,
                    failedText: "تلاش ناموفق",
                    completeText: "بازیابی شد",
                    refreshingText: "درحال بازیابی",
                    idleText: "یه پایین بکشید",
                    releaseText: "رها کنید",
                    spacing: 2,
                  ),
                  onRefresh: () => BlocProvider.of<CartBloc>(context)
                      .add(const CartRefreshEvent(isRefreshFromSmart: true)),
                  child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                      itemCount: state.response.cartItems.length + 1,
                      itemBuilder: (conetxt, index) {
                        if (index < state.response.cartItems.length) {
                          final cartItem = state.response.cartItems[index];
                          return CartItemWidget(
                            themeData: themeData,
                            cartItem: cartItem,
                            onSuccess: () {
                              BlocProvider.of<CartBloc>(context).add(
                                  const CartRefreshEvent(
                                      isRefreshFromSmart: false));
                            },
                          );
                        } else {
                          return PriceInfo(
                            totalPrcie: state.response.totalPrice,
                            shippingCost: state.response.shippingCost,
                            payablePrice: state.response.payablePrice,
                          );
                        }
                      }),
                ),
              );
            } else if (state is CartAuthRequiredState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "به حساب کاربری خود وارد شوید",
                      style: themeData.textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                  builder: (context) => const AuthScreen()));
                        },
                        child: Text(
                          "ورود",
                          style: themeData.textTheme.bodyLarge
                              ?.apply(color: themeData.colorScheme.surface),
                        ))
                  ],
                ),
              );
            } else {
              throw Exception("Unknown State in Cart Screen");
            }
          },
        ),
      ),
    );
  }
}
