import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/customer_hot/customer_hot.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield_controller.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield.dart';
import 'package:flutter_dealxemay_2024/schedule/schedule.dart';
import 'package:flutter_dealxemay_2024/services/common_service.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:http/http.dart' as http;

class DenyBuySchedule extends StatefulWidget {
  final dynamic objCustomer;
  final String username;
  const DenyBuySchedule(
      {super.key, required this.objCustomer, required this.username});

  @override
  State<DenyBuySchedule> createState() => _DenyBuyScheduleState();
}

class _DenyBuyScheduleState extends State<DenyBuySchedule> {
  late List<dynamic> lstDenyReason = [];
  TextEditingController txtNoiDung = TextEditingController();
  String? selectedDeny;
  Future<void> getDenyReason() async {
    var data = await CommonService.getDenyReason();

    setState(() {
      lstDenyReason = data;
    });
  }

  Future<void> saveDenyCustomer() async {
    final headers = {'Content-Type': 'application/json'};
    if (validateSubmit()) {
      // luu khach hang tu choi
      var uri = Uri.parse('${urlApi}createDenyCustomer');
      var response = await http.post(uri,
          headers: headers, body: jsonEncode(widget.objCustomer));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (!mounted) return;
        if (data["isError"] == false) {
          ToastsCustom.showToastSucess(data["message"], context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Schedule(username: widget.username)));
        } else {
          ToastsCustom.showToastError(data["message"], context);
        }
      }
    }
  }

  bool validateSubmit() {
    List<String> errors = [];
    // chon it nhat 1 ket qua cham soc
    if (selectedDeny == null) {
      errors.add("Vui lòng chọn lý do từ chối");
    }
    // bat buoc nhap noi dung "trao doi voi khach" va "noi dung dat lich"
    // var noidung= txtNoiDung.text;
    // if (noidung.isEmpty) {
    //   errors.add("Vui lòng nhập nội dung từ chối");
    // }

    if (errors.isNotEmpty) {
      for (var error in errors) {
        ToastsCustom.showToastWarning(error, context);
      }
      return false;
    } else {
      widget.objCustomer["DenyNote"] = txtNoiDung.text;
      widget.objCustomer["DenyReason"] = selectedDeny.toString();
      widget.objCustomer["UserName"] = widget.username;
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    getDenyReason();
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
          "Từ chối mua xe",
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                constraints: BoxConstraints(
                  maxHeight: (MediaQuery.sizeOf(context).height * 2) /
                      5, // Giới hạn chiều cao
                ),
                child: ListView.builder(
                  itemCount: lstDenyReason.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: RadioListTile(
                        title: Text(
                          lstDenyReason[index]["name"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        value: lstDenyReason[index]["code"],
                        groupValue: selectedDeny,
                        onChanged: (dynamic value) {
                          setState(() {
                            selectedDeny = value; // Cập nhật giá trị nhóm
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.zero,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFieldController(
                  name: 'Nội dung', controller: txtNoiDung, readOnly: false),
              const SizedBox(
                height: 10,
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
                    onPressed: () => saveDenyCustomer(),
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
      ),
    );
  }
}
