import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/repo/auth_repo.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/profile/order/order_history.dart';
import 'package:nike/ui/profile/bloc/profile_bloc.dart';
import 'package:nike/ui/profile/favorites/favorites.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final AuthInfo? authInfo = AuthRepository.authValueNotifire.value;
    late bool isLogin;
    if (authInfo != null && authInfo.accessToken.isNotEmpty) {
      isLogin = true;
    } else {
      isLogin = false;
    }
    ProfileBloc? bloc;

    return BlocProvider<ProfileBloc>(
      create: (context) {
        bloc = ProfileBloc(authRepository: authRepository, isLogin: isLogin);
        return bloc!;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("پروفایل"),
            centerTitle: true,
          ),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 68,
                      width: 68,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 32, bottom: 12),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: LightTheme.secondryTextColor),
                          shape: BoxShape.circle),
                      child: Image.asset("assets/img/nike_logo.png"),
                    ),
                  ),
                  Text(
                    state.isLogin ? "userEmail@gmail.com" : "کاربر مهمان",
                    style: themeData.textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(
                    height: 1,
                    endIndent: 16,
                    indent: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: ((context) => const FavoritesScreen())));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.heart,
                            size: 26,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            "لیست علاقه مندی ها",
                            style: themeData.textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    endIndent: 16,
                    indent: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const OrderHistoryScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.shopping_cart,
                            size: 26,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            "سوابق سفارش",
                            style: themeData.textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    endIndent: 16,
                    indent: 16,
                  ),
                  InkWell(
                    onTap: () {
                      if (state.isLogin) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: const Text("خروج از حساب کاربری"),
                                  content: const Text(
                                      "آایا میخواهید از حساب کاربری خود خارج شوید؟"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          bloc?.add(
                                              ProfileLogoutButtonClickedEvent());
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("بله")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("خیر")),
                                  ],
                                ),
                              );
                            });
                      } else {
                        Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                                builder: (context) => const AuthScreen()));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        children: [
                          Icon(
                            state.isLogin
                                ? CupertinoIcons.arrow_right_square
                                : CupertinoIcons.arrow_left_square,
                            size: 26,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            state.isLogin
                                ? "خروج از حساب کاربری"
                                : "ورود به حساب کاربری",
                            style: themeData.textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    endIndent: 16,
                    indent: 16,
                  ),
                ],
              );
            },
          )),
    );
  }
}
