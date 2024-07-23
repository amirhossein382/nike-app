import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/data/data.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/ui/details/details.dart';
import 'package:nike/ui/utils.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.themeData,
    required this.borderRadius,
    this.itemWidth = 176,
    this.itemHeight = 189,
    this.aspecRatio = 0.93,
  });

  final ProductJson product;
  final ThemeData themeData;
  final BorderRadius borderRadius;
  final double itemWidth;
  final double itemHeight;
  final double aspecRatio;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => DetailScreen(
                  product: product,
                )));
      },
      borderRadius: borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                  aspectRatio: aspecRatio,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )),
              Positioned(
                  top: 5,
                  right: 10,
                  child: _HeartButton(product: product, themeData: themeData))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8),
            child: Text(
              maxLines: 2,
              product.title,
              style: themeData.textTheme.titleSmall!
                  .apply(overflow: TextOverflow.ellipsis),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 4),
            child: Text(
              product.previousPrice.withPriceLabel,
              style: themeData.textTheme.bodySmall!
                  .copyWith(decoration: TextDecoration.lineThrough),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 4),
            child: Text(
              product.price.withPriceLabel,
              style: themeData.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartButton extends StatefulWidget {
  const _HeartButton({
    required this.product,
    required this.themeData,
  });

  final ProductJson product;
  final ThemeData themeData;

  @override
  State<_HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<_HeartButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: favoriteManager.listenable,
      builder: (context, value, child) => InkWell(
        onTap: () {
          if (!favoriteManager.isFavorite(widget.product)) {
            favoriteManager.addFavorite(widget.product);
          } else {
            favoriteManager.removeFavorite(widget.product);
          }
          setState(() {});
        },
        child: Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.themeData.colorScheme.background),
          child: favoriteManager.isFavorite(widget.product)
              ? const Icon(
                  CupertinoIcons.heart_fill,
                  size: 22,
                  color: Colors.red,
                )
              : const Icon(
                  CupertinoIcons.heart,
                  size: 22,
                ),
        ),
      ),
    );
  }
}
