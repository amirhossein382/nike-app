import 'package:flutter/material.dart';

class AppExceptionWidget extends StatelessWidget {
  final Function() onPressed;
  const AppExceptionWidget({
    super.key,
    required this.themeData,
    required this.onPressed,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        "تلاش دوباره",
        style: themeData.textTheme.bodyMedium,
      ),
    ));
  }
}
