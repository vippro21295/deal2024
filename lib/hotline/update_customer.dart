import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/hotline/appoinment_result.dart';
import 'package:flutter_dealxemay_2024/models/data_customers.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield_controller.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UpdateCustomer extends StatefulWidget {
  final String username;
  final String cusid;
  const UpdateCustomer(
      {super.key, required this.username, required this.cusid});

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  late Future<dynamic> infoCustomer;
  late DataCustomers dataCus;
  late List<dynamic> listBestModel = [];
  final dropDownKey = GlobalKey<DropdownSearchState>();
  TextEditingController txtExtPhone = TextEditingController();
  TextEditingController txtThoiGian = TextEditingController();
  TextEditingController txtHoTen  = TextEditingController();
  late List<String> lstExtPhone = [];
  String selectedModelMotor = "";

  Future<dynamic> getInfoCustomer() async {
    var queryParameters = {'username': widget.username, 'custid': widget.cusid};

    var uri = Uri.parse('${urlApi}getInfoCustomer')
        .replace(queryParameters: queryParameters);

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['isError'] == false) {
          dynamic results = data['obj'];
          dataCus = DataCustomers.fromJson(results);
          selectedModelMotor = dataCus.interestingColors!;
          return results;
        } else {
          if (!mounted) return;
          ToastsCustom.showToastError(data["message"], context);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ToastsCustom.showToastError(e.toString(), context);
    }
  }

  Future<void> getBestModel() async {
    var uri = Uri.parse('${urlApi}getBestModel');

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['isError'] == false) {
          List<dynamic> results = data['lstobj'];
          // Chuyển đổi danh sách JSON thành danh sách đối tượng DataObject

          if (results.isNotEmpty) {
            for (var item in results) {
              var it = {
                "id": item["Id"],
                "name": item["ModelCode"] +
                    '-' +
                    item["ModelName"] +
                    '-' +
                    item["ColorCode"]
              };
              listBestModel.add(it);
            }
          }
        } else {
          if (!mounted) return;
          ToastsCustom.showToastError(data["message"], context);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ToastsCustom.showToastError(e.toString(), context);
    }
  }

  Future<void> updateCustomer() async {
    // tao du lieu gui qua apponitment
    if (isNumeric(txtThoiGian.text)) {
      dataCus.email = txtThoiGian.text;
    } else {
      ToastsCustom.showToastWarning(
          "Vui lòng nhập thời gian chăm sóc là số phút", context);
      txtThoiGian.text = '0';
      return;
    }

    dataCus.statusLevel = 5303;
    dataCus.extPhone = getExtPhone();
    dataCus.interestingColors = selectedModelMotor;
    dataCus.fullName = txtHoTen.text;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AppoinmentResult(userName: widget.username, objectCus: dataCus)));
  }

  String selectedModelColor(String id) {
    if (id.isEmpty || listBestModel.isEmpty) {
      return "";
    }

    final selectedItem = listBestModel.firstWhere(
      (item) => item["id"].toString() == id,
    );
    if (selectedItem != null) {
      return "${selectedItem["name"]}";
    } else {
      return "";
    }
  }

  void addExtPhone() {
    var extPhone = txtExtPhone.text;

    if ((extPhone.toString().length == 10 ||
            extPhone.toString().length == 11) &&
        isNumeric(extPhone)) {
      setState(() {
        lstExtPhone.add(extPhone);
        txtExtPhone.text = "";
      });
    } else {
      ToastsCustom.showToastWarning(
          "Vui lòng nhập số điện thoại 10 - 11 số", context);
    }
  }

  String getExtPhone() {
    if (lstExtPhone.isEmpty) {
      return "";
    } else {
      var extP = "";
      for (var item in lstExtPhone) {
        extP = "$extP$item,";
      }
      extP = extP.substring(0, extP.length - 1);
      return extP;
    }
  }

  void deleteExtPhone(index) {
    setState(() {
      lstExtPhone.removeAt(index);
    });
  }

  bool isNumeric(String? s) {
    if (s == null || s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
    infoCustomer = loadInfoCustomer(); // Gọi một hàm async trả về Future
    txtThoiGian.text = "0";
  
  }

  Future<dynamic> loadInfoCustomer() async {
    await getBestModel(); // Đợi getBestModel hoàn thành
    return getInfoCustomer(); // Trả về dữ liệu infoCustomer
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
          txtHoTen.text = data["FullName"].toString();
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
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: CustomTextFieldController(
                              name: "Họ tên khách hàng:",
                              controller: txtHoTen,
                              readOnly: false ,
                            ),
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
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: CustomTextFieldController(
                              name: "Thời gian chăm sóc: (phút)",
                              controller: txtThoiGian,
                              readOnly: false,                            
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: CustomTextFieldController(
                            name: "Số điện thoại khác:",
                            controller: txtExtPhone,
                            readOnly: false,                         
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextButton(
                              onPressed: () => addExtPhone(),
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
                    lstExtPhone.isEmpty
                        ? const SizedBox(
                            height: 20,
                          )
                        : Column(children: [
                            ListView.builder(
                              shrinkWrap:
                                  true, // Cho phép danh sách tự điều chỉnh chiều cao
                              physics:
                                  const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn riêng cho ListView
                              itemCount: lstExtPhone.length,
                              itemBuilder: (context, index) {
                                final item = lstExtPhone[
                                    index]; // Lấy phần tử từ lstExtPhone
                                return SizedBox(
                                  height: 25,
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        const Text('-'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          item,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 3, 64, 169)),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => {deleteExtPhone(index)},
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                    // Hiển thị số điện thoại
                                  ),
                                );
                              },
                            ),
                          ]),
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
                          child: DropdownSearch<String>(
                            key: dropDownKey,
                            popupProps: const PopupProps.menu(
                              showSelectedItems: true,
                              showSearchBox: true,
                            ),
                            items: listBestModel
                                .map((item) => (item["name"]) as String)
                                .toList(),
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Loại xe - Màu xe quan tâm nhất",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 15, 113, 174)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            onChanged: (selectedName) {
                              // Tìm `id` tương ứng dựa trên `name` đã chọn
                              final selectedItem = listBestModel.firstWhere(
                                (item) => item["name"] == selectedName,
                                orElse: () => null,
                              );
                              if (selectedItem != null) {
                                setState(() {
                                  selectedModelMotor =
                                      selectedItem["id"].toString();
                                });
                              }
                            },
                            selectedItem: selectedModelColor(
                              data["InterestingColors"].toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
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
                            onPressed: () => updateCustomer(),
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
