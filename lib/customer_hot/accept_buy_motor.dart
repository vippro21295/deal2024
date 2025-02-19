import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/customer_hot/customer_hot.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield.dart';
import 'package:flutter_dealxemay_2024/services/common_service.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AcceptBuyMotor extends StatefulWidget {
  final dynamic objCustomer;
  final String username;
  const AcceptBuyMotor(
      {super.key, required this.objCustomer, required this.username});

  @override
  State<AcceptBuyMotor> createState() => _AcceptBuyMotorState();
}

class _AcceptBuyMotorState extends State<AcceptBuyMotor> {
  late List<dynamic> lstBestModel = [];
  final dropDownKey = GlobalKey<DropdownSearchState>();
  DateTime _selectedDate = DateTime.now();
  String selectedModelMotor = "";

  Future<void> getListBestModel() async {
    var data = await CommonService.getBestModel();
    setState(() {
      lstBestModel = data;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return; // Không chọn ngày thì thoát

    // Chọn giờ
    final TimeOfDay? selectedTime = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (selectedTime == null) return; // Không chọn giờ thì thoát
// Kết hợp ngày và giờ
    final DateTime combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Cập nhật trạng thái
    setState(() {
      _selectedDate = combinedDateTime;
    });
  }

  String selectedModelColor(String id) {
    if (id.isEmpty || lstBestModel.isEmpty) {
      return "";
    }

    final selectedItem = lstBestModel.firstWhere(
      (item) => item["id"].toString() == id,
    );
    if (selectedItem != null) {
      return "${selectedItem["name"]}";
    } else {
      return "";
    }
  }

  Future<void> saveBuyMotor() async {
    if (validateSubmit()) {
      var queryParameters = {
        'custID': widget.objCustomer["CustID"],
        'userName': widget.username,
        'modelBuy': selectedModelMotor,
        'buyDate': _selectedDate.toIso8601String()
      };

      var uri = Uri.parse('${urlApi}updateBuyMotor')
          .replace(queryParameters: queryParameters);
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (!mounted) return;
        if (data["isError"] == false) {
          ToastsCustom.showToastSucess(data["message"], context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CustomerHot(username: widget.username)));
        } else {
          ToastsCustom.showToastError(data["message"], context);
        }
      }
    }
  }

  bool validateSubmit() {
    List<String> errors = [];
    // kiem tra thoi gian mua xe
    var diff = DateTime.now().difference(_selectedDate).inMinutes;
    if (diff < 0) {
      errors.add('Thời gian mua xe phải nhỏ hơn thời gian hiện tại');
    }

    if (diff > (24 * 60 * 3)) {
      errors.add('Thời gian mua xe phải trong vòng 3 ngày gần nhất');
    }

    if (errors.isNotEmpty) {
      for (var error in errors) {
        ToastsCustom.showToastWarning(error, context);
      }
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    getListBestModel();
    selectedModelMotor = widget.objCustomer["InterestingColorsCode"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Đồng ý mua xe",
            style: TextStyle(
                color: Color.fromARGB(255, 41, 34, 246),
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color.fromARGB(255, 183, 183, 183),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: CustomTextField(
                        name: "Họ tên khách hàng:",
                        initValue: widget.objCustomer["FullName"],
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
                        name: "Số điện thoại:",
                        initValue: widget.objCustomer["Phone"],
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
                        name: "Nhân viên bán hàng:",
                        initValue: widget.objCustomer["CreatedBy"],
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
                        items: lstBestModel
                            .map((item) => (item["name"]) as String)
                            .toList(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Loại xe - Màu xe quan đã mua",
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
                          final selectedItem = lstBestModel.firstWhere(
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
                          widget.objCustomer["InterestingColorsCode"]
                              .toString(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            isDense:
                                true, // Làm cho khoảng cách giữa labelText và nội dung gọn hơn
                            labelText:
                                'Ngày mua', // Tiêu đề giống như TextFormField
                            border: OutlineInputBorder(
                              // Đường viền giống TextFormField
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Text(
                              DateFormat('kk:mm dd/MM/yyyy')
                                  .format(_selectedDate),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 2, 147, 16),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size(50, 30)),
                      onPressed: () => saveBuyMotor(),
                      child: const Row(
                        children: [
                          Icon(Icons.save, size: 15),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Lưu',
                            style: TextStyle(fontSize: 11),
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
                              const Color.fromARGB(255, 212, 47, 1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size(50, 30)),
                     onPressed: (){
                        Navigator.pop(context);
                     },
                      child: const Row(
                        children: [
                          Icon(Icons.close, size: 15),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Đóng',
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
