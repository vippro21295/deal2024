import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DialogHistory {
  static void showHistory(BuildContext context, List<dynamic> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Lịch sử chăm sóc',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red),
            ),
          ),
          content: SizedBox(
            height: 300.0, // Change as per your requirement
            width: 500.0, // Change as per
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy kk:mm').format(
                              DateTime.parse(items[index]["Createddate"]),
                            ),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              items[index]["Note"],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              items[index]["Detail"],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey, // Màu của đường kẻ
                        thickness: 1.0, // Độ dày của đường kẻ
                        indent: 0.0, // Khoảng cách từ cạnh trái
                        endIndent: 0.0, // Khoảng cách từ cạnh phải
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Đóng',
              ),
            ),
          ],
        );
      },
    );
  }
}
