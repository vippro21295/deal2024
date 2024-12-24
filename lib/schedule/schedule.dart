import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter_dealxemay_2024/customer_hot/accept_buy_motor.dart';
import 'package:flutter_dealxemay_2024/customer_hot/add_customers.dart';
import 'package:flutter_dealxemay_2024/customer_hot/create_appoinment_result.dart';
import 'package:flutter_dealxemay_2024/customer_hot/deny_buy_motor.dart';
import 'package:flutter_dealxemay_2024/history.dart';
import 'package:flutter_dealxemay_2024/hotline/appoinment_result.dart';
import 'package:flutter_dealxemay_2024/models/data_customers.dart';
import 'package:flutter_dealxemay_2024/schedule/accept_buy_schedule.dart';
import 'package:flutter_dealxemay_2024/schedule/deny_buy_schedule.dart';
import 'package:flutter_dealxemay_2024/schedule/update_schedule.dart';
import 'package:flutter_dealxemay_2024/services/common_service.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:flutter_dealxemay_2024/hotline/update_customer.dart';
import 'package:http/http.dart' as http;
import '../services/globals.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Schedule extends StatefulWidget {
  final String username;
  const Schedule({super.key, required this.username});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late Future<List<dynamic>> _dataFuture;
  DateTime fromDate = DateTime.now().add(const Duration(days: -1));
  DateTime toDate = DateTime.now();
  String? selectedType = 'CHT';
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> dataType = [
    {'id': 'TC', 'name': 'Tất cả'},
    {'id': 'CHT', 'name': 'Chưa hoàn tất'},
    {'id': 'HT', 'name': 'Hoàn tất'},
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataFuture = fetchDataAlert();
    });
  }

  Future<List<dynamic>> fetchDataAlert() async {
    var queryParameters = {
      'username': widget.username,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),   
      'keySearch': searchController.text,
      'day': '',
      'departmentId': '0',
      'dataType': selectedType
    };

    var uri = Uri.parse('${urlApi}getListSchedule')
        .replace(queryParameters: queryParameters);

    try {
      var response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // Giai ma JSON

        if (data['isError'] == false) {
          List<dynamic> results = data["lstObj"];
          // Chuyển đổi danh sách JSON thành danh sách đối tượng DataObject
          return results;
        } else {
          return [];
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
          ToastsCustom.showToastSucess(data['message'], context);
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

  Future<void> createAppoinment(item, context) async {
    var queryParameters = {
      "custId": item["CustID"]
    };

     var uri = Uri.parse('${urlApi}getAppointMentResultBefore')
        .replace(queryParameters: queryParameters);

    var response = await http.get(uri);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      if(data["isError"] == false){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAppoinmentResult(userName: widget.username, objectCus: item, lastAppointmentResult: data["obj"])));
      }
    }
  }

Future<void> openHistory(item, context) async {
    var data = await CommonService.getHistoryCustomer(item["CustID"]);
    DialogHistory.showHistory(context, data);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
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
          List<dynamic> data = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                "Lịch hẹn chăm sóc",
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
                                          item["ReferenceChannelName"] ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item["AppointmentStatus"] ?? "",
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
                                                item["FullName"] ?? "",
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
                                              item["Phone"],
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
                                                          item["CreatedDate"])),
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
                                                  item["AppointmentDate"] ?? "",
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
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item["LastAppointmentResult"] ?? "",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color.fromARGB(
                                                        255, 9, 9, 9)),
                                              ),
                                            ),
                                            Text(
                                              item["StatusLevelName"] ?? "",
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.blue),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item["InterestingColors"] ??
                                                      "",
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 11,
                                                      color: Color.fromARGB(
                                                          255, 1, 99, 8)),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                    item["ApoinmentNote"] ?? "",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 1, 1, 1),
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Visibility(
                                    visible: true,
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
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 145, 145, 2),
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    minimumSize:
                                                        const Size(50, 30)),
                                                onPressed: () =>
                                                    createAppoinment(item, context),
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.add, size: 15),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      'Tạo kết quả đặt lịch',
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 100, 181, 247),
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    minimumSize:
                                                        const Size(50, 30)),
                                                onPressed: () =>
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateSchedule(objCustomer: item, username: widget.username,))),
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.update,
                                                        size: 15),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      'Cập nhật',
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 31, 190, 6),
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    minimumSize:
                                                        const Size(50, 30)),
                                                onPressed: () => {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AcceptBuySchedule(
                                                                objCustomer:
                                                                    item,
                                                                username: widget
                                                                    .username,
                                                              )))
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.open_in_new,
                                                        size: 15),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      'Đồng ý',
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 222, 79, 17),
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    minimumSize:
                                                        const Size(50, 30)),
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DenyBuySchedule(
                                                                objCustomer:
                                                                    item,
                                                                username: widget
                                                                    .username))),
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.close, size: 15),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      'Từ chối',
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const
                                                        Color.fromARGB(255, 122, 1, 110),
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    minimumSize:
                                                        const Size(50, 30)),
                                                onPressed: () =>
                                                    openHistory(item, context),
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.calculate, size: 15),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      'Lịch sử chăm sóc',
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Hiện tại chưa có lịch hẹn chăm sóc')),
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
