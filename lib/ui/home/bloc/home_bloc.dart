import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/data.dart';
import 'package:nike/data/repo/banner_repo.dart';
import 'package:nike/data/repo/product_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;

  HomeBloc({required this.bannerRepository, required this.productRepository})
      : super(HomeLoadingState()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStartdEvent || event is HomeRefreshEvent) {
        try {
          emit(HomeLoadingState());
          final banners = await bannerRepository.getAll();
          final latestProducts =
              await productRepository.getAll(ProductSort.lastes);
          final popularProducts =
              await productRepository.getAll(ProductSort.popular);

          emit(HomeSuccessState(
              banners: banners,
              latestProducts: latestProducts,
              popularProducts: popularProducts));
        } catch (e) {
          emit(HomeErrorState(exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
