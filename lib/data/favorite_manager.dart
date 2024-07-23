import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike/data/data.dart';

final FavoriteManager favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = "nike";
  final _box = Hive.box<ProductJson>(_boxName);

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductJsonAdapter());
    await Hive.openBox<ProductJson>(_boxName);
  }

  void addFavorite(ProductJson product) {
    _box.put(product.id, product);
  }

  void removeFavorite(ProductJson product) {
    _box.delete(product.id);
  }

  List<ProductJson> get favorites => _box.values.toList();

  ValueListenable<Box<ProductJson>> get listenable => _box.listenable();

  bool isFavorite(ProductJson product) {
    return _box.containsKey(product.id);
  }
}
