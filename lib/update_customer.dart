import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dealxemay_2024/appoinment_result.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:flutter_dealxemay_2024/services/toasts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UpdateCustomer extends StatefulWidget {
  const UpdateCustomer({super.key});

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  late Future<dynamic> infoCustomer;

  Future<dynamic> getInfoCustomer() async {
    var queryParameters = {
      'username': '02010',
      'custid': '8e8dc8d7-ea81-492d-bdce-6aa3c59232d5'
    };

    var uri = Uri.parse('${urlApi}getInfoCustomer')
        .replace(queryParameters: queryParameters);

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['isError'] == false) {
          dynamic results = data['obj'];
          // Chuyển đổi danh sách JSON thành danh sách đối tượng DataObject
          return results;
        } else {
          ToastService.showToastError(data["message"]);
        }
      }
    } catch (e) {
      ToastService.showToastError(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      infoCustomer = getInfoCustomer();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: infoCustomer, // Future sẽ được theo dõi
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
          dynamic data = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Cập nhật khách hàng",
                style: TextStyle(
                    color: Color.fromARGB(255, 41, 34, 246),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              backgroundColor: const Color.fromARGB(255, 183, 183, 183),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: CustomTextField(
                            name: "Nguồn khách hàng: ",
                            initValue: data["ReferenceChannelName"].toString(),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: CustomTextField(
                            name: "Họ tên khách hàng:",
                            initValue: data["FullName"].toString(),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: CustomTextField(
                            name: "Điện thoại:",
                            initValue: data["Phone"].toString(),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Flexible(
                          flex: 4,
                          child: CustomTextField(
                            name: "Thời gian chăm sóc: (phút)",
                            initValue: "0",
                            readOnly: false,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Flexible(
                          child: CustomTextField(
                            name: "Số điện thoại khác:",
                            initValue: "",
                            readOnly: false,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: TextButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 242, 111, 74),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  minimumSize: const Size(40, 40)),
                              child: const Icon(Icons.add)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: CustomTextField(
                            name: "Ngày tiếp khách hàng:",
                            initValue: DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(data["ContactDate"]))
                                .toString(),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: CustomTextField(
                            name: "Ngày tạo:",
                            initValue: DateFormat('dd/MM/yyyy')
                                .format(DateTime.now())
                                .toString(),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: CustomTextField(
                            name: "Loại xe - Màu xe quan tâm nhất:",
                            initValue: data["FullName"].toString(),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 246, 46, 15),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size(50, 40)),
                          onPressed: () => {},
                          child: const Row(
                            children: [
                              Icon(Icons.close, size: 15),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Hủy',
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 100, 181, 247),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size(50, 40)),
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AppoinmentResult()))
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.update, size: 15),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Cập nhật khách hàng',
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
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
