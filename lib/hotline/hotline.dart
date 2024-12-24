import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter_dealxemay_2024/models/data_hotline.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:flutter_dealxemay_2024/hotline/update_customer.dart';
import 'package:http/http.dart' as http;
import '../services/globals.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Hotline extends StatefulWidget {
  final String username;
  const Hotline({super.key, required this.username});

  @override
  State<Hotline> createState() => _HotlineState();
}

class _HotlineState extends State<Hotline> {
  late Future<List<DataHotline>> _dataFuture;
  DateTime fromDate = DateTime.now().add(const Duration(days: -10));
  DateTime toDate = DateTime.now();
  String? selectedType = 'CC';
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> dataType = [
    {'id': 'TC', 'name': 'Tất cả'},
    {'id': 'DC', 'name': 'Đã chuyển'},
    {'id': 'CC', 'name': 'Chưa chuyển'},
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataFuture = fetchDataAlert();
    });
  }

  Future<List<DataHotline>> fetchDataAlert() async {
    var queryParameters = {
      'username': widget.username,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'keySearch': searchController.text,
      'type': selectedType
    };

    var uri = Uri.parse('${urlApi}getHotline')
        .replace(queryParameters: queryParameters);

    try {
      var response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // Giai ma JSON

        if (data['isError'] == false) {
          List<dynamic> results = data["listObj"];
          // Chuyển đổi danh sách JSON thành danh sách đối tượng DataObject
          List<DataHotline> dataObjects = results.map((item) {
            return DataHotline.fromJson(item);
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

  Future<void> recivedHotline(custid) async {
    var queryParameters = {
      'custid': custid,
      'username': widget.username,
    };

    var uri = Uri.parse('${urlApi}recivedHotline')
        .replace(queryParameters: queryParameters);

    try {
      var response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // Giai ma JSON
        if (!mounted) return;
        if (data['isError'] == false) {
          _refreshData();
        } else {
          ToastsCustom.showToastError(data['message'], context);
        }
      } else {
        throw Exception('Error from API');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  Future<void> callHotline(phone) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: "+84${phone.toString().substring(1, 10)}",
    );
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      // Nếu không mở được ứng dụng gọi điện
      if (!mounted) return;
      ToastsCustom.showToastError("Không mở được ứng dụng gọi điện", context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DataHotline>>(
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
          List<DataHotline> data = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Hotline",
                style: TextStyle(
                    color: Color.fromARGB(255, 41, 34, 246),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              actions: [
                IconButton(
                  onPressed: () => showFilterDialog(context),
                  icon: const Icon(Icons.search,
                      color: Color.fromARGB(255, 41, 34, 246)),
                ),
              ],
              backgroundColor: const Color.fromARGB(255, 183, 183, 183),
            ),
            body: RefreshIndicator(
              onRefresh: _refreshData,
              child: data.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: ListTile(
                            tileColor: const Color.fromARGB(255, 249, 241, 241),
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: const BorderSide(
                                width: 0.5,
                                color: Color.fromARGB(255, 111, 111, 111),
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15.0,
                                        child: Image.asset(
                                          'assets/icon/source_hotline.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.referenChannelName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.statusName,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color:
                                                Color.fromRGBO(251, 112, 12, 1),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.fullName.toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color.fromARGB(
                                                      255, 41, 0, 246),
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.phone,
                                              size: 14,
                                              color:
                                                  Color.fromARGB(255, 3, 3, 3),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              item.isRecived
                                                  ? item.phone
                                                  : '${item.phone.substring(0, 7)}xxx',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color.fromARGB(
                                                      255, 6, 0, 0),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time_outlined,
                                                  size: 13,
                                                  color: Color.fromARGB(
                                                      255, 3, 3, 3),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  DateFormat(
                                                          'kk:mm dd/MM/yyyy ')
                                                      .format(DateTime.parse(
                                                          item.createdDate)),
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.alarm_on,
                                                  size: 13,
                                                  color: Color.fromARGB(
                                                      255, 3, 3, 3),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  DateFormat(
                                                          'kk:mm dd/MM/yyyy ')
                                                      .format(DateTime.parse(
                                                          item.recivedDealDate)),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color.fromARGB(
                                                        255, 251, 3, 3),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              item.interestingLevel,
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey, // Màu của đường kẻ
                                    thickness: 1.0, // Độ dày của đường kẻ
                                    indent: 0.0, // Khoảng cách từ cạnh trái
                                    endIndent: 0.0, // Khoảng cách từ cạnh phải
                                  ),
                                  Text(
                                    item.note,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 1, 1, 1),
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Visibility(
                                    visible:
                                        !item.isRecived && item.status == 'CC',
                                    child: Column(
                                      children: [
                                        const Divider(
                                          color:
                                              Colors.grey, // Màu của đường kẻ
                                          thickness: 1.0, // Độ dày của đường kẻ
                                          indent:
                                              0.0, // Khoảng cách từ cạnh trái
                                          endIndent:
                                              0.0, // Khoảng cách từ cạnh phải
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 100, 181, 247),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  minimumSize:
                                                      const Size(50, 30)),
                                              onPressed: () =>
                                                  recivedHotline(item.custID),
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.download,
                                                      size: 15),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Nhận khách hàng',
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        item.isRecived && item.status == 'CC',
                                    child: Column(
                                      children: [
                                        const Divider(
                                          color:
                                              Colors.grey, // Màu của đường kẻ
                                          thickness: 1.0, // Độ dày của đường kẻ
                                          indent:
                                              0.0, // Khoảng cách từ cạnh trái
                                          endIndent:
                                              0.0, // Khoảng cách từ cạnh phải
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 242, 111, 74),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  minimumSize:
                                                      const Size(50, 30)),
                                              onPressed: () =>
                                                  callHotline(item.phone),
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.phone, size: 15),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Gọi',
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 105, 171, 64),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  minimumSize:
                                                      const Size(50, 30)),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateCustomer(
                                                            username:
                                                                widget.username,
                                                            cusid: item.custID),
                                                  ),
                                                );
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.update, size: 15),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Cập nhật khách hàng',
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Hiện tại chưa có hotline nào cần chăm sóc')),
            ),
          );
        } else {
          return const Center(child: Text('Không có dữ liệu'));
        }
      },
    );
  }

  void showFilterDialog(BuildContext context) {
    // Khởi tạo các giá trị ban đầu cho bộ lọc

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Tìm kiếm',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    const Text('Từ ngày: '),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fromDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            fromDate = pickedDate;
                          });
                        }
                      },
                      child: Text(DateFormat('dd/MM/yyyy').format(fromDate)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Đến ngày: '),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: toDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            toDate = pickedDate;
                          });
                        }
                      },
                      child: Text(DateFormat('dd/MM/yyyy').format(toDate)),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Hình thức'),
                  value: selectedType, // Giá trị ban đầu là `id`
                  items: dataType.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'], // Giá trị là `id`
                      child: Text(item['name']!), // Hiển thị là `name`
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedType = value; // Cập nhật `selectedId` với `id` mới
                    // Bạn có thể thêm logic cập nhật khác ở đây nếu cần
                  },
                ),
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Từ khóa',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Đóng',
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Thực hiện tìm kiếm với các lựa chọn hiện tại
                  _refreshData();
                },
                child: const Text('Tìm kiếm'),
              ),
            ],
          );
        });
      },
    );
  }
}
