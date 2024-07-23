import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/cart_item.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/cart/cart_item/bloc/cart_item_bloc.dart';
import 'package:nike/ui/utils.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.themeData,
    required this.cartItem,
    required this.onSuccess,
  });

  final ThemeData themeData;
  final CartItemEntity cartItem;
  final GestureTapCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        CartItemBloc bloc = CartItemBloc(cartRepository);

        bloc.stream.forEach((state) {
          if (state is CartItemDeleteErrorState ||
              state is CartItemChangeCountErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("خطای نا مشخص")));
          } else if (state is CartItemDeleteSuccessState ||
              state is CartItemChangeCountSuccessState) {
            onSuccess();
            cartRepository.count();
          }
        });
        return bloc;
      },
      child: Card.filled(
        color: themeData.colorScheme.surface,
        child: BlocBuilder<CartItemBloc, CartItemState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cartItem.product.imageUrl,
                          height: 100,
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Text(
                          cartItem.product.title,
                          maxLines: 2,
                          style: themeData.textTheme.titleLarge!.apply(
                              fontSizeFactor: .8,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "تعداد",
                          style: themeData.textTheme.titleMedium,
                        ),
                        Row(children: [
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<CartItemBloc>(context).add(
                                  CartItemPlusButtonClickedEvent(
                                      cartItemId: cartItem.id,
                                      cartItemCount: cartItem.count));
                            },
                            icon: const Icon(
                              CupertinoIcons.plus_rectangle,
                              size: 22,
                            ),
                          ),
                          state is CartItemChangeCountLoadingState
                              ? const CupertinoActivityIndicator(
                                  color: LightTheme.primaryColor,
                                )
                              : Text(cartItem.count.toString()),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<CartItemBloc>(context).add(
                                  CartItemMinusButtonClickedEvent(
                                      cartItemCount: cartItem.count,
                                      cartItemId: cartItem.id));
                            },
                            icon: const Icon(
                              CupertinoIcons.minus_rectangle,
                              size: 22,
                            ),
                          ),
                        ])
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          cartItem.product.previousPrice.withPriceLabel,
                          style: themeData.textTheme.bodySmall!
                              .apply(decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          cartItem.product.price.withPriceLabel,
                          style: themeData.textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(
                  color: LightTheme.secondryTextColor,
                  indent: 4,
                  endIndent: 4,
                ),
                TextButton(
                    onPressed: () {
                      BlocProvider.of<CartItemBloc>(context).add(
                          CartItemDeleteButtonClickedEvent(
                              cartItemId: cartItem.id));
                    },
                    child: state is CartItemDeleteLoadingState
                        ? CupertinoActivityIndicator(
                            color: themeData.primaryColor,
                          )
                        : Text(
                            "حذف از سبد خرید",
                            style: themeData.textTheme.titleLarge!.apply(
                              fontSizeFactor: .8,
                            ),
                          ))
              ],
            );
          },
        ),
      ),
    );
  }
}
