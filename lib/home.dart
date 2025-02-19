import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/customer_hot/customer_b.dart';
import 'package:flutter_dealxemay_2024/customer_hot/customer_d.dart';
import 'package:flutter_dealxemay_2024/customer_hot/customer_hot.dart';
import 'package:flutter_dealxemay_2024/customer_hot/customer_w.dart';

class HomeWiget extends StatefulWidget {
  final String username;
  const HomeWiget({required this.username, super.key});

  @override
  State<HomeWiget> createState() => _HomeWigetState();
}

class _HomeWigetState extends State<HomeWiget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
  appBar: AppBar(
    automaticallyImplyLeading: false,
    title: const Text(
      'Trang chủ',
      style: TextStyle(
          color: Color.fromARGB(255, 41, 34, 246),
          fontSize: 16,
          fontWeight: FontWeight.w600),
    ),
    centerTitle: true,
    backgroundColor: const Color.fromARGB(255, 183, 183, 183),
  ),
  body: Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2.1,
                  height: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 158, 232, 249),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Bo tròn nhẹ
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerHot(username: widget.username)));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icon/source_hotline.png',
                          height: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'KH có thông tin',
                          style: TextStyle(
                            color: Color.fromARGB(255, 12, 24, 255),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: SizedBox(
                   width: MediaQuery.of(context).size.width / 2.1,
                  height: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 158, 232, 249),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Bo tròn nhẹ
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerW(username: widget.username)));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icon/no-data.png',
                          height: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'KH không có thông tin',
                          style: TextStyle(
                            color: Color.fromARGB(255, 12, 24, 255),
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Center(
                child: SizedBox(
                 width: MediaQuery.of(context).size.width / 2.1,
                  height: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 158, 232, 249),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Bo tròn nhẹ
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDeny(username: widget.username)));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icon/deny-buy.png',
                          height: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'KH từ chối mua xe',
                          style: TextStyle(
                            color: Color.fromARGB(255, 12, 24, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: SizedBox(
                   width: MediaQuery.of(context).size.width / 2.1,
                  height: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 158, 232, 249),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Bo tròn nhẹ
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerBuy(username: widget.username)));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icon/accept-buy.png',
                          height: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'KH đã mua xe',
                          style: TextStyle(
                            color: Color.fromARGB(255, 12, 24, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  ),
)

;
  }
}
