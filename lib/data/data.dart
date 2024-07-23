import 'package:hive_flutter/hive_flutter.dart';

part 'data.g.dart';

class ProductSort {
  static const int lastes = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int priceLowToHigh = 3;
}

final Map productSortName = {
  ProductSort.lastes: "جدید ترین",
  ProductSort.popular: "محبوب ترین",
  ProductSort.priceLowToHigh: "بیشترین به کمترین",
  ProductSort.priceHighToLow: "کمترین به بیشترین"
};

@HiveType(typeId: 0)
class ProductJson {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int price;

  @HiveField(2)
  final int discount;

  @HiveField(3)
  final int previousPrice;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String imageUrl;

  ProductJson(this.id, this.price, this.discount, this.previousPrice,
      this.title, this.imageUrl);

  ProductJson.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image'],
        price = json['price'],
        discount = json['discount'],
        previousPrice = json['previous_price'] ?? json['price'];
}

class BannerJson {
  final int id;
  final String image;

  BannerJson.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'];
}

class CommentJson {
  final int id;
  final String title;
  final String content;
  final String date;
  final String email;

  CommentJson.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json['title'],
        content = json['content'],
        email = json['author']['email'],
        date = json['date'];
}
