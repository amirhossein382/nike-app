import 'dart:async';
import 'package:nike/data/data.dart';
import 'package:nike/data/source/banner_source.dart';

final BannerRepository bannerRepository =
    BannerRepository(dataSource: BannerDataSource());

abstract class IBannerRepository {
  Future<List<BannerJson>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository({required this.dataSource});

  @override
  Future<List<BannerJson>> getAll() => dataSource.getAll();
}
