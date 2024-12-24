import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter_dealxemay_2024/models/data_alert.dart';
import 'package:http/http.dart' as http;
import './services/globals.dart';
import 'package:intl/intl.dart';

class AlertContent extends StatefulWidget {
  final String username;
  const AlertContent({super.key, required this.username});

  @override
  State<AlertContent> createState() => _AlertContentState();
}

class _AlertContentState extends State<AlertContent> {
  late Future<List<DataAlert>> _dataFuture;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dataFuture = fetchDataAlert();
    });
  }

  Future<List<DataAlert>> fetchDataAlert() async {
    var queryParameters = {
      'username': widget.username,
    };

    var uri = Uri.parse('${urlApi}getAlert')
        .replace(queryParameters: queryParameters);

    try {
      var response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // Giai ma JSON

        if (data['isError'] == false) {
          List<dynamic> results = data["listObj"];
          // Chuyển đổi danh sách JSON thành danh sách đối tượng DataObject
          List<DataAlert> dataObjects = results.map((item) {
            return DataAlert.fromJson(item);
          }).toList();

          return dataObjects;
        } else {
          throw Exception('Error from API');
        }
      } else {
        throw Exception('Error from API');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  // Hàm tải lại dữ liệu
  Future<void> _refreshData() async {
    setState(() {
      _dataFuture = fetchDataAlert(); // Gọi lại phương thức để tải dữ liệu
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DataAlert>>(
      future: _dataFuture, // Future sẽ được theo dõi
      builder: (context, snapshot) {
        // Kiểm tra trạng thái của snapshot
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hiển thị spinner chờ dữ liệu
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Hiển thị lỗi nếu có
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Hiển thị dữ liệu sau khi đã tải thành công
          List<DataAlert> data = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Thông báo",
                style: TextStyle(
                    color: Color.fromARGB(255, 41, 34, 246),
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              backgroundColor: const Color.fromARGB(255, 183, 183, 183),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      tileColor: (){
                        if(index % 2 != 0){
                          return const Color.fromARGB(255, 207, 206, 206);
                        }
                      }(),
                      leading: () {
                        if (item.messageStatus == 'N') {
                          return const Icon(Icons.phone, color: Colors.black);
                        } else {
                          return const Icon(Icons.notifications_active,
                              color: Colors.red);
                        }
                      }(),
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              item.messageStatus == 'N'
                                  ? "Thông báo nhận BO"
                                  : "Thông báo nhắc nhở BO",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: item.messageStatus == 'N'
                                      ? Colors.black
                                      : Colors.red),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.message,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: item.messageStatus == 'N'
                                      ? Colors.black
                                      : Colors.red,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 3),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                DateFormat('kk:mm dd/MM/yyyy ')
                                    .format(DateTime.parse(item.createdDate)),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Color.fromARGB(255, 32, 43, 247)),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('Không có dữ liệu'));
        }
      },
    );
  }
}
