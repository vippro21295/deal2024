import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/alert.dart';
import 'package:flutter_dealxemay_2024/hotline.dart';
import 'package:flutter_dealxemay_2024/login.dart';
import 'package:flutter_dealxemay_2024/provider/data_provider.dart';
import 'package:flutter_dealxemay_2024/setting.dart';
import 'package:flutter_dealxemay_2024/web_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeWiget extends StatefulWidget {
  const HomeWiget({super.key});

  @override
  State<HomeWiget> createState() => _HomeWigetState();
}

class _HomeWigetState extends State<HomeWiget> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  late String username = "";
  late String password = "";
  late String tokenLogin = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getInitUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _logout() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  getInitUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenLogin = prefs.getString('token') ?? '';
      username = prefs.getString('username') ?? '';
      password = prefs.getString('password') ?? 'PT123456';
      isLoading = false;
    });
  }

  List<Widget> _buildScreen() {
    return [
      WebViewDeal(username: username, password: password),
      Hotline(username: username),
      AlertContent(key: UniqueKey(), username: username),
      Setting(onLogout: _logout),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItem(value) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Trang chủ",
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.phone),
        title: "Hotline",
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: value.count == 0
            ? const Icon(Icons.notifications_active)
            : Badge(
                label: Text(value.count.toString()),
                child: const Icon(Icons.notifications_active),
              ),
        title: "Thông báo",
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.settings,
        ),
        title: "Cài đặt",
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Loading indicator
      );
    } else {
      return Consumer<CountAlert>(
        builder: (context, value, child) => PersistentTabView(
          context,
          screens: _buildScreen(),
          items: _navBarItem(value),
          controller: _controller,
          backgroundColor: const Color.fromARGB(255, 183, 183, 183),
          navBarStyle: NavBarStyle.style3,
          onItemSelected: (value) => {
            if (value == 1)
              {
                context.read<CountAlert>().updateCount(0),
              },
          },
        ),
      );
    }
  }
}
