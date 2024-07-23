import 'package:flutter/material.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/data/repo/auth_repo.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/root.dart';

void main() async {
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const TextStyle defaultFontFamily = TextStyle(fontFamily: "IranYekan");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                side: const MaterialStatePropertyAll(
                    BorderSide(color: LightTheme.secondryTextColor)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                const MaterialStatePropertyAll(LightTheme.primaryColor),
            shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: defaultFontFamily.apply(
              color: LightTheme.primaryTextColor.withOpacity(.8)),
        ),
        indicatorColor: LightTheme.primaryColor,
        dividerTheme:
            const DividerThemeData(color: LightTheme.secondryTextColor),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all(defaultFontFamily))),
        textTheme: TextTheme(
          titleLarge: defaultFontFamily.copyWith(fontWeight: FontWeight.w700),
          titleMedium:
              defaultFontFamily.apply(color: LightTheme.secondryTextColor),
          titleSmall: defaultFontFamily,
          bodyMedium: defaultFontFamily,
          bodySmall:
              defaultFontFamily.apply(color: LightTheme.secondryTextColor),
        ),
        colorScheme: const ColorScheme.light(
            primary: LightTheme.primaryColor,
            secondary: LightTheme.secondryColor,
            surface: Colors.white,
            onSecondary: Colors.white),
        useMaterial3: true,
        snackBarTheme: SnackBarThemeData(
            contentTextStyle: defaultFontFamily.apply(color: Colors.white),
            backgroundColor: Theme.of(context).colorScheme.secondary),
      ),
      home: ValueListenableBuilder(
        valueListenable: AuthRepository.authValueNotifire,
        builder: (context, value, child) {
          final bool isAuthenticated;
          if (value != null) {
            isAuthenticated = (value.accessToken.isNotEmpty);
          } else {
            isAuthenticated = false;
          }

          return isAuthenticated ? const RootScreen() : const AuthScreen();
        },
      ),
    );
  }
}
