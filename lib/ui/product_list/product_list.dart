import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/data.dart';
import 'package:nike/data/repo/product_repo.dart';
import 'package:nike/ui/details/product.dart';
import 'package:nike/ui/product_list/bloc/product_list_bloc.dart';

class ProductListScreen extends StatefulWidget {
  final int sorted;
  const ProductListScreen({super.key, required this.sorted});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    int sortedValue = widget.sorted;

    return BlocProvider<ProductListBloc>(
      create: (context) {
        bloc = ProductListBloc(productRepository);
        bloc?.add(ProductListStartedEvent(sortedValue));
        return bloc!;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeData.colorScheme.surface,
            title: const Text("کفش های ورزشی"),
          ),
          body: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListSuccessState) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: themeData.colorScheme.surface,
                          boxShadow: const [
                            BoxShadow(blurRadius: 2, color: Colors.black)
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 4, bottom: 8),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      CupertinoIcons.sort_down,
                                      size: 26,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Card.filled(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: Container(
                                                      height: 4,
                                                      width: 48,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                    ),
                                                  ),
                                                  Text(
                                                    "انتخاب لیست مرتب سازی",
                                                    style: themeData
                                                        .textTheme.titleLarge,
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            productSortName
                                                                .length,
                                                        itemBuilder:
                                                            ((context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 8, 8, 8),
                                                            child: InkWell(
                                                              onTap: () {
                                                                bloc?.add(
                                                                    ProductListChangedSortedEvent(
                                                                        index));
                                                                setState(() {
                                                                  sortedValue =
                                                                      index;
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    productSortName[
                                                                        index],
                                                                    style: themeData
                                                                        .textTheme
                                                                        .bodyLarge
                                                                        ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  if (sortedValue ==
                                                                      index)
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .check_mark_circled_solid,
                                                                      size: 22,
                                                                      color: themeData
                                                                          .colorScheme
                                                                          .primary,
                                                                    )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        })),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "مرتب سازی",
                                          style: themeData.textTheme.titleMedium
                                              ?.apply(color: Colors.black),
                                        ),
                                        Text(
                                          productSortName[sortedValue],
                                          style: themeData.textTheme.bodySmall,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 48,
                            color: Colors.grey,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                viewType == ViewType.grid
                                    ? viewType = ViewType.list
                                    : viewType = ViewType.grid;
                              });
                            },
                            icon: Icon(
                              viewType == ViewType.grid
                                  ? CupertinoIcons.square_grid_2x2
                                  : CupertinoIcons.list_dash,
                              size: 26,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      viewType == ViewType.grid ? .60 : .75,
                                  crossAxisCount:
                                      viewType == ViewType.grid ? 2 : 1,
                                  crossAxisSpacing: 14),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return ProductItem(
                                product: product,
                                themeData: themeData,
                                borderRadius: BorderRadius.zero);
                          }),
                    ),
                  ],
                );
              } else if (state is ProductListLoadingState) {
                return Center(
                  child: CupertinoActivityIndicator(
                    color: themeData.colorScheme.primary,
                  ),
                );
              } else {
                return const Center(
                  child: Text("خطای نا مشخص"),
                );
              }
            },
          )),
    );
  }
}
