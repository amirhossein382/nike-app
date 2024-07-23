import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/auth/bloc/auth_bloc.dart';
import 'package:nike/ui/root.dart';

final _formKey = GlobalKey<FormState>();

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackgrundColor = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(width: 1, color: onBackgrundColor),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: onBackgrundColor, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            labelStyle: const TextStyle(color: onBackgrundColor, fontSize: 14),
          ),
        ),
        child: BlocProvider<AuthBloc>(
          create: (context) {
            final AuthBloc bloc = AuthBloc();
            bloc.stream.forEach((state) {
              if (state is AuthSuccessState) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const RootScreen()));
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.exception.message)));
              }
            });
            return bloc;
          },
          child: Scaffold(
            backgroundColor: themeData.colorScheme.secondary,
            body: Padding(
              padding: const EdgeInsets.only(right: 22, left: 22),
              child: ContentBody(
                  onBackgrundColor: onBackgrundColor, themeData: themeData),
            ),
          ),
        ),
      ),
    );
  }
}

class ContentBody extends StatelessWidget {
  ContentBody({
    super.key,
    required this.onBackgrundColor,
    required this.themeData,
  });

  final Color onBackgrundColor;
  final ThemeData themeData;

  final TextEditingController password = TextEditingController();

  final TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) {
        return current is AuthErrorState ||
            current is AuthInitial ||
            current is AuthLoadingState ||
            current is AuthChangedPageModeState;
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/nike_logo.png',
                color: onBackgrundColor,
                width: 100,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "خوش آمدید",
                style: themeData.textTheme.titleLarge!
                    .apply(color: onBackgrundColor),
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                state.isLoginMode
                    ? "لطفا وارد حساب کاربری خود شوید"
                    : "آدرس ایمیل و  رمز ورورد خود را ثبت کنید",
                style: themeData.textTheme.titleSmall!
                    .apply(color: onBackgrundColor),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: username,
                style: TextStyle(color: onBackgrundColor, letterSpacing: 1.5),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("آدرس ایمیل"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "لطفا آدرس ایمیل خود را وارد کنید";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 18,
              ),
              _PasswordTextField(
                onBackgrundColor: onBackgrundColor,
                password: password,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(54))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<AuthBloc>(context).add(
                          AuthButtonClickedEvent(
                              username: username.text,
                              password: password.text));
                    }
                  },
                  child: state is AuthLoadingState
                      ? CupertinoActivityIndicator(
                          color: themeData.colorScheme.onSecondary,
                        )
                      : Text(
                          state.isLoginMode ? "ورود" : "ثبت نام",
                          style: themeData.textTheme.titleSmall
                              ?.apply(color: themeData.colorScheme.surface),
                        )),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.isLoginMode
                        ? "آیا حسابی ندارید؟"
                        : "آیا حساب کاربری دارید؟",
                    style: themeData.textTheme.bodyMedium!.apply(
                      color: onBackgrundColor,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthCtrlLoginMode());
                    },
                    child: Text(
                      state.isLoginMode ? 'ثبت نام' : 'ورود',
                      style: themeData.textTheme.bodyMedium!.apply(
                          color: LightTheme.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: LightTheme.primaryColor),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.onBackgrundColor,
    required this.password,
  });

  final Color onBackgrundColor;
  final TextEditingController password;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureTextState = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.password,
      style: TextStyle(color: widget.onBackgrundColor, letterSpacing: 1.5),
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecureTextState,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obsecureTextState = !obsecureTextState;
            });
          },
          icon: obsecureTextState
              ? const Icon(CupertinoIcons.eye_slash)
              : const Icon(CupertinoIcons.eye),
          color: widget.onBackgrundColor.withOpacity(.6),
        ),
        label: const Text("رمز ورود"),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "لطفا رمز عبور خود را وارد کنید";
        }
        return null;
      },
    );
  }
}
