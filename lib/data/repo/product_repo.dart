import 'package:nike/data/data.dart';
import 'package:nike/data/source/product_source.dart';

String url = "http://expertdevelopers.ir/api/v1/product/list?sort=3";

final ProductRepository productRepository =
    ProductRepository(dataSource: ProductDataSource());

abstract class IProductRepository {
  Future<List<ProductJson>> getAll(int sort);
  Future<List<ProductJson>> search(String search);
}

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository({required this.dataSource});
  @override
  Future<List<ProductJson>> getAll(int sort) => dataSource.getAll(sort);

  @override
  Future<List<ProductJson>> search(String search) => dataSource.search(search);
}
