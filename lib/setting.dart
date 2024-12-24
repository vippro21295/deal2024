import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  final VoidCallback onLogout; // Tạo một callback để xử lý đăng xuất
  const Setting({super.key, required this.onLogout});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  @override
  void initState() {
    super.initState();
  }


  login() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Đăng xuất khỏi tài khoản của bạn'),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((result) {
      if (result == true) {
       widget.onLogout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Cài đặt",
            style: TextStyle(
                color: Color.fromARGB(255, 41, 34, 246),
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color.fromARGB(255, 183, 183, 183),
        ),
        body: SafeArea(
          child: Column(
            children: [
              MaterialButton(
                onPressed: login,
                color: const Color.fromARGB(255, 1, 149, 247),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        "ĐĂNG XUẤT",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
