import 'dart:convert';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import '../services/globals.dart';
import 'package:intl/intl.dart';

class CustomerW extends StatefulWidget {
  final String username;
  const CustomerW({super.key, required this.username});

  @override
  State<CustomerW> createState() => _CustomerWState();
}

class _CustomerWState extends State<CustomerW> {
  late Future<List<dynamic>> _dataFuture;
  DateTime fromDate = DateTime.now().add(const Duration(days: -1));
  DateTime toDate = DateTime.now();
  String? selectedType = '';
  TextEditingController searchController = TextEditingController();
  String title = 'Khách hàng không có thông tin';
  List<Map<String, String>> dataType = [
    {'id': '', 'name': 'Tất cả'},
    {'id': 'Q', 'name': 'Quá hạn(Chưa gửi)'},
    {'id': 'QD', 'name': 'Quá hạn(Đã gửi)'},
    {'id': 'C', 'name': 'Chưa gửi(chưa quá hạn)'},
    {'id': 'R', 'name': 'Đã gửi'},
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
      'typeCustomer': 'W',
      'keySearch': '',
      'departmentId': '',
      'isSendSMS': '',
      'motorHot': ''
    };

    var uri = Uri.parse('${urlApi}getListCustomerAll')
        .replace(queryParameters: queryParameters);

    try {
      var response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // Giai ma JSON

        if (data['isError'] == false) {
          List<dynamic> results = data["lstobj"];
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
              title:  Text(title                ,
                style: const TextStyle(
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
                                      const Expanded(
                                        child:  Text(
                                          'KHÁCH HÀNG KHÔNG CÓ THÔNG TIN',
                                          overflow: TextOverflow.ellipsis,
                                          style:  TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
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
                                                item["CreatedBy"],
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color.fromARGB(
                                                      255, 41, 0, 246),
                                                ),
                                              ),
                                            ),
                                            
                                            Text(
                                               DateFormat(
                                                          'kk:mm dd/MM/yyyy ')
                                                      .format(DateTime.parse(
                                                          item["CreatedDate"])),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color.fromARGB(
                                                      255, 6, 0, 0),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        
                                       
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item["ReasonNoInfo"] ??
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Hiện tại chưa có khách hàng có thông tin')),
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
