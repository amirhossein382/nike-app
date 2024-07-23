import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/data.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/details/addToCart/bloc/add_to_cart_bloc.dart';
import 'package:nike/ui/details/comment/bloc/comment_bloc.dart';
import 'package:nike/ui/utils.dart';
import 'package:nike/ui/widgets/app_exception.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.product});
  final ProductJson product;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<AddToCartBloc>(
        create: (context) {
          final AddToCartBloc bloc = AddToCartBloc();
          bloc.stream.forEach((state) {
            if (state is AddToCartSuccessState) {
              scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text("با موفقیت به سبد خرید اضافه شد")));
              cartRepository.count();
            } else if (state is AddToCartErrorState) {
              scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: BlocBuilder<AddToCartBloc, AddToCartState>(
              builder: (context, state) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  height: 55,
                  child: FloatingActionButton.extended(
                      backgroundColor: themeData.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      onPressed: () {
                        debugPrint(
                            "cart notifire value ------->${CartRepository.cartValueNotifire.value}");
                        int randomNumber = Random().nextInt(200);
                        BlocProvider.of<AddToCartBloc>(context)
                            .add(AddToCartClickedEvent(productId: product.id));
                        CartRepository.cartValueNotifire.value = randomNumber;
                        debugPrint(
                            "cart notifire value ------->${CartRepository.cartValueNotifire.value}");
                      },
                      label: state is AddToCartLoadingState
                          ? CupertinoActivityIndicator(
                              color: themeData.colorScheme.onSecondary,
                            )
                          : Text(
                              "افزودن به سبد خرید",
                              style: themeData.textTheme.titleSmall!
                                  .apply(color: themeData.colorScheme.surface),
                            )),
                );
              },
            ),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                maxLines: 2,
                                product.title,
                                style: themeData.textTheme.titleLarge!.apply(
                                    fontSizeFactor: .8,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              width: 48,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  product.previousPrice.withPriceLabel,
                                  style: themeData.textTheme.bodySmall!.apply(
                                      decoration: TextDecoration.lineThrough),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  product.price.withPriceLabel,
                                  style: themeData.textTheme.bodyMedium,
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          maxLines: 2,
                          'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا. هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                          style: themeData.textTheme.bodyMedium!
                              .apply(overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: themeData.textTheme.titleMedium,
                            ),
                            TextButton(
                                onPressed: () {}, child: const Text('ثبت نظر'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommentListSliver(
                  id: product.id,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommentListSliver extends StatelessWidget {
  final int id;
  const CommentListSliver({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocProvider(
      create: (context) {
        final CommentBloc bloc = CommentBloc(id);
        bloc.add(CommentStartedEvent());
        return bloc;
      },
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state is CommentLoadingState) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is CommentErrorState) {
            return AppExceptionWidget(
              themeData: themeData,
              onPressed: () {},
            );
          } else if (state is CommentSuccessState) {
            return SliverList(
                delegate: SliverChildBuilderDelegate(
                    childCount: state.comments.sublist(0, 8).length,
                    (context, index) {
              final data = state.comments[index];
              return Container(
                margin: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: themeData.dividerColor.withOpacity(.2)),
                    borderRadius: BorderRadius.circular(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title,
                              style: themeData.textTheme.titleSmall,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              data.email,
                              style: themeData.textTheme.bodySmall,
                            )
                          ],
                        ),
                        Text(
                          data.date,
                          style: themeData.textTheme.bodySmall,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.content,
                      style: themeData.textTheme.bodyMedium!.apply(
                        fontSizeFactor: .9,
                      ),
                    )
                  ],
                ),
              );
            }));
          } else {
            throw Exception(" Unknown state cathced");
          }
        },
      ),
    );
  }
}
