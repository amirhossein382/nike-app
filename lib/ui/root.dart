import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/cart/cart.dart';
import 'package:nike/ui/home/home.dart';
import 'package:nike/ui/profile/profile.dart';
import 'package:nike/ui/widgets/badge.dart';

const int _homeIndex = 0;
const int _cartIndex = 1;
const int _profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = _homeIndex;
  List history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late Map map = {
    _homeIndex: _homeKey,
    _profileIndex: _profileKey,
    _cartIndex: _cartKey
  };
  late NavigatorState currentNavState = map[selectedScreenIndex]!.currentState!;

  Future<bool> _onWillPop() async {
    if (currentNavState.canPop()) {
      currentNavState.pop();
      return false;
    } else if (history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = history.last;
        var last = history.removeLast();
        debugPrint("---------> $last");
      });
      return false;
    } else if (history.isEmpty) {
      debugPrint("history is empty! ...");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: NavigatorPopHandler(
        onPop: _onWillPop,
        child: Scaffold(
          body: IndexedStack(index: selectedScreenIndex, children: [
            _navigator(_homeKey, _homeIndex, const HomeScreen()),
            _navigator(_cartKey, _cartIndex, const CartScreen()),
            _navigator(_profileKey, _profileIndex, const ProfileScreen()),
          ]),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                history.remove(index);
                history.add(index);
                selectedScreenIndex = index;
                debugPrint("history ----------> $history");
              });
            },
            currentIndex: selectedScreenIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: "خانه",
              ),
              BottomNavigationBarItem(
                  icon: BadgeIcon(icon: Icon(CupertinoIcons.cart)),
                  label: "سبد خرید"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: "پروفایل"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int screenIndex, Widget child) {
    return key.currentState == null && selectedScreenIndex != screenIndex
        ? const SizedBox()
        : Offstage(
            offstage: selectedScreenIndex != screenIndex,
            child: Navigator(
              key: key,
              onGenerateRoute: (settings) =>
                  MaterialPageRoute(builder: (context) => child),
            ),
          );
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }
}
