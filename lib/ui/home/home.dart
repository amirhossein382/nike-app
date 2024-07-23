import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/data.dart';
import 'package:nike/data/repo/banner_repo.dart';
import 'package:nike/data/repo/product_repo.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/details/product.dart';
import 'package:nike/ui/home/bloc/home_bloc.dart';
import 'package:nike/ui/product_list/product_list.dart';
import 'package:nike/ui/utils.dart';
import 'package:nike/ui/widgets/app_exception.dart';
import 'package:nike/ui/widgets/slider_widget.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) {
          final HomeBloc homeBloc = HomeBloc(
              bannerRepository: bannerRepository,
              productRepository: productRepository);
          homeBloc.add(HomeStartdEvent());
          return homeBloc;
        },
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeErrorState) {
                  return AppExceptionWidget(
                    themeData: themeData,
                    onPressed: () {
                      BlocProvider.of<HomeBloc>(context)
                          .add(HomeRefreshEvent());
                    },
                  );
                } else if (state is HomeSuccessState) {
                  return _HomeContent(
                    state: state,
                    themeData: themeData,
                  );
                } else {
                  throw Exception("undefined state! ....");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeSuccessState state;
  final ThemeData themeData;
  const _HomeContent({
    required this.state,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _AppBar(),
          SliderWidget(
              state: state,
              imgPath: "assets/img/banner_1.jpg",
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(12)),
          _HorizantalProductsList(
            themeData: themeData,
            products: state.latestProducts,
            title: 'جدیدترین',
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: ((context) =>
                      const ProductListScreen(sorted: ProductSort.lastes))));
            },
          ),
          const SizedBox(
            height: 4,
          ),
          _HorizantalProductsList(
            themeData: themeData,
            products: state.popularProducts,
            title: "پربازدیدترین",
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: ((context) =>
                      const ProductListScreen(sorted: ProductSort.popular))));
            },
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Center(
              child: Image.asset(
            "assets/img/nike_logo.png",
            height: 28,
          )),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 48,
            child: TextField(
              decoration: InputDecoration(
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(
                        width: 1, color: LightTheme.secondryTextColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: LightTheme.secondryTextColor, width: 1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  prefixIcon: const Icon(CupertinoIcons.search)),
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizantalProductsList extends StatelessWidget {
  const _HorizantalProductsList({
    required this.themeData,
    required this.products,
    required this.title,
    required this.onTap,
  });

  final ThemeData themeData;
  final List<ProductJson> products;
  final String title;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: themeData.textTheme.titleMedium,
              ),
              TextButton(onPressed: onTap, child: const Text("مشاهده همه"))
            ],
          ),
        ),
        SizedBox(
          height: 298,
          child: ListView.builder(
              physics: defaultScrollPhysics,
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              padding: const EdgeInsets.only(left: 4, right: 4),
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  width: 176,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductItem(
                      product: product,
                      themeData: themeData,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
