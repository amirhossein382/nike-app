import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.callToAction});

  final String imagePath;
  final String text;
  final Widget callToAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imagePath,
            height: 180,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            text,
            style: themeData.textTheme.bodyLarge,
          ),
          callToAction
        ],
      ),
    );
  }
}
