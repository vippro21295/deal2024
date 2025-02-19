import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/alert.dart';
import 'package:flutter_dealxemay_2024/customer_hot/customer_hot.dart';
import 'package:flutter_dealxemay_2024/home.dart';
import 'package:flutter_dealxemay_2024/hotline/hotline.dart';
import 'package:flutter_dealxemay_2024/login.dart';
import 'package:flutter_dealxemay_2024/provider/data_provider.dart';
import 'package:flutter_dealxemay_2024/schedule/schedule.dart';
import 'package:flutter_dealxemay_2024/setting.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigatorWiget extends StatefulWidget {
  const NavigatorWiget({super.key});

  @override
  State<NavigatorWiget> createState() => _NavigatorWigetState();
}

class _NavigatorWigetState extends State<NavigatorWiget> {
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
      HomeWiget(username: username),
      Schedule(username: username),
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
        icon: const Icon(Icons.calendar_month),
        title: "Lịch hẹn",
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
