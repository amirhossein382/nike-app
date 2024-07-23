import 'package:flutter/material.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/theme.dart';

class BadgeIcon extends StatelessWidget {
  final Icon icon;
  const BadgeIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [icon, const Positioned(top: -5, right: -10, child: _Badge())],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CartRepository.cartItemCountNotifire,
      builder: (context, value, child) => Visibility(
        visible: value > 0,
        child: Container(
          alignment: Alignment.center,
          height: 18,
          width: 18,
          decoration: const BoxDecoration(
              color: LightTheme.primaryColor, shape: BoxShape.circle),
          child: Text(
            value.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
