import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/data.dart';
import 'package:nike/data/repo/product_repo.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository productRepository;
  ProductListBloc(this.productRepository) : super(ProductListInitialState()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStartedEvent ||
          event is ProductListChangedSortedEvent) {
        try {
          emit(ProductListLoadingState());
          final products = await productRepository.getAll(event.sorted);
          emit(ProductListSuccessState(products: products));
        } catch (e) {
          emit(ProductListErrorState(
              exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
