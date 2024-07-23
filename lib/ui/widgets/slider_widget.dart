import 'package:flutter/material.dart';
import 'package:nike/ui/home/bloc/home_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    super.key,
    required this.state,
    required this.imgPath,
    required this.borderRadius,
    required this.padding,
  });

  final HomeSuccessState state;
  final String imgPath;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    final ThemeData themeData = Theme.of(context);
    return AspectRatio(
      aspectRatio: 2,
      child: PageView.builder(
          controller: controller,
          itemCount: state.banners.length,
          itemBuilder: ((context, index) {
            // debugPrint(state.banners[index].image);
            return Padding(
              padding: padding,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                        borderRadius: borderRadius,
                        child: Image.network(
                          state.banners[index].image,
                          fit: BoxFit.fill,
                        )),
                  ),
                  Positioned(
                      bottom: 8,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: state.banners.length,
                          axisDirection: Axis.horizontal,
                          effect: WormEffect(
                              spacing: 6,
                              radius: 4.0,
                              dotWidth: 22,
                              dotHeight: 3,
                              paintStyle: PaintingStyle.stroke,
                              strokeWidth: 1.5,
                              dotColor: Colors.grey,
                              activeDotColor: themeData.colorScheme.secondary),
                        ),
                      ))
                ],
              ),
            );
          })),
    );
  }
}
