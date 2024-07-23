part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoadingState extends HomeState {}

final class HomeErrorState extends HomeState {
  final AppException exception;

  const HomeErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class HomeSuccessState extends HomeState {
  final List<BannerJson> banners;
  final List<ProductJson> latestProducts;
  final List<ProductJson> popularProducts;

  const HomeSuccessState(
      {required this.banners,
      required this.latestProducts,
      required this.popularProducts});
}
