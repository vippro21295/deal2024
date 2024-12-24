import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield_controller.dart';
import 'package:flutter_dealxemay_2024/schedule/schedule.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UpdateSchedule extends StatefulWidget {
  final dynamic objCustomer;
  final String username;
  const UpdateSchedule(
      {super.key, required this.objCustomer, required this.username});

  @override
  State<UpdateSchedule> createState() => _UpdateScheduleState();
}

class _UpdateScheduleState extends State<UpdateSchedule> {
  List<String> lstTime = [];
  DateTime _selectedDate = DateTime.now();

  TextEditingController txtNoiDungDatLich = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> updateSchedule() async {
    if (validateSubmit()) {
      var queryParameters = {
        'username': widget.username,
        'appointId': widget.objCustomer["AppointmentId"],
        'appointDate': _selectedDate.toIso8601String(),
        'appointNote': txtNoiDungDatLich.text
      };

      var uri = Uri.parse('${urlApi}updateAppointment')
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
                      Schedule(username: widget.username)));
        } else {
          ToastsCustom.showToastError(data["message"], context);
        }
      }
    }
  }

  bool validateSubmit() {
    List<String> errors = [];

    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    var defaultDate = dateFormat.parse(widget.objCustomer["AppointmentDate"]);
    var datediff = defaultDate.difference(_selectedDate).inDays;
    if (datediff > 0) {
      errors.add("Vui lòng chọn ngày đặt hẹn bằng hoặc lớn hơn ban đầu");
    }

    var noidung = txtNoiDungDatLich.text;
    if (noidung.isEmpty) {
      errors.add("Vui lòng nhập nội dung đặt lịch");
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
    setState(() {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      _selectedDate = dateFormat
          .parse(widget.objCustomer["AppointmentDate"] ?? DateTime.now());
      txtNoiDungDatLich.text = widget.objCustomer["ApoinmentNote"] ?? "";
    });
    print(widget.objCustomer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cập nhật lịch chăm sóc",
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        isDense:
                            true, // Làm cho khoảng cách giữa labelText và nội dung gọn hơn
                        labelText:
                            'Ngày hẹn', // Tiêu đề giống như TextFormField
                        border: OutlineInputBorder(
                          // Đường viền giống TextFormField
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: CustomTextFieldController(
                  name: 'Nội dung đặt lịch',
                  controller: txtNoiDungDatLich,
                  readOnly: false,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 2, 147, 16),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: const Size(50, 30)),
                    onPressed: () => updateSchedule(),
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
                        backgroundColor: const Color.fromARGB(255, 212, 47, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: const Size(50, 30)),
                    onPressed: () => () {},
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
      ),
    );
  }
}
