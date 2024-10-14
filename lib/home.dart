import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/alert.dart';
import 'package:flutter_dealxemay_2024/web_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
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

  getInitUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      password = prefs.getString('password') ?? '';
      isLoading = false;
    });
  }

  List<Widget> _buildScreen() {
    return [
      WebViewDeal(username: username, password: password),
      AlertContent(username: username),
      const Text('Tinh nang chua hoan thien'),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItem() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.home), title: "Trang chủ"),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.notifications_active), title: "Thông báo"),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings), title: "Cài đặt"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Loading indicator
      );
    } else {
      return PersistentTabView(
        context,
        screens: _buildScreen(),
        items: _navBarItem(),
        controller: _controller,
        backgroundColor: const Color.fromARGB(255, 183, 183, 183),
      );
    }
  }
}
