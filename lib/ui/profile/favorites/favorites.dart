import 'package:flutter/material.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/ui/details/product.dart';
import 'package:nike/ui/widgets/emtpy_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("لیست علاقه مندی ها"),
      ),
      body: ValueListenableBuilder(
        builder: (context, value, index) {
          return Expanded(
            child: favoriteManager.favorites.isEmpty
                ? const EmptyState(
                    imagePath: "assets/img/no_data.svg",
                    text: "لیست شما خالی است",
                    callToAction: SizedBox())
                : ListView.builder(
                    itemCount: favoriteManager.favorites.length,
                    itemBuilder: ((context, index) {
                      final product = favoriteManager.favorites[index];
                      return ProductItem(
                          aspecRatio: 1.6,
                          product: product,
                          themeData: themeData,
                          borderRadius: BorderRadius.circular(8));
                    })),
          );
        },
        valueListenable: favoriteManager.listenable,
      ),
    );
  }
}
