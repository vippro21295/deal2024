import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/hotline/hotline.dart';
import 'package:flutter_dealxemay_2024/models/data_customers.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield_controller.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AppoinmentResult extends StatefulWidget {
  final DataCustomers objectCus;
  final String userName;
  const AppoinmentResult(
      {super.key, required this.userName, required this.objectCus});

  @override
  State<AppoinmentResult> createState() => _AppoinmentResultState();
}

class _AppoinmentResultState extends State<AppoinmentResult> {
  late List<dynamic> listResultDATCOC = [];
  late List<dynamic> listResultCHUACOC = [];
  bool isCheckChuaCoc = true; // mac dinh la chua coc
  bool isGoToBranch = false;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime = "09:00";
  final TextEditingController txtTraoDoiVoiKhach = TextEditingController();
  final TextEditingController txtNoiDungDatLich = TextEditingController();
  List<String> lstTime = [];

  late dynamic appresult = {'MeetingResult': '', 'MeetingNote': ''};
  late dynamic appoint = {
    'ApoinmentNote': '',
    'AppointmentDates': '',
    'IsDeleted': false
  };

  @override
  void initState() {
    super.initState();
    getAppointmentResult();
    genTime();
  }

  Future<void> getAppointmentResult() async {
    var uri = Uri.parse('${urlApi}getAppoinmentResult');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var data = body["lstobj"];
      setState(() {
        listResultDATCOC =
            data.where((item) => item["Status"] == 'DATCOC').toList();
        listResultCHUACOC =
            data.where((item) => item["Status"] == 'CHUACOC').toList();
      });
    }
  }

  

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

  genTime() {
    for (int hour = 7; hour < 20; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        String formattedTime =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        lstTime.add(formattedTime);
      }
    }
  }

  Future<dynamic> addAppointmentResult() async {
    // kiem tra dieu kien truoc khi luu
    final headers = {'Content-Type': 'application/json'};
    if (validateSubmit()) {
      if (isCheckChuaCoc) {
        widget.objectCus.statusLevel = 5303;
      } else {
        widget.objectCus.statusLevel = 5302;
      }

      var queryBody = {
        'username': widget.userName,
        'customer': jsonEncode(widget.objectCus.toJson()),
        'appoint': jsonEncode(appoint),
        'result': jsonEncode(appresult),
      };
      var uri = Uri.parse('${urlApi}updateCustomerHotLineToHot');
      try {
        var response =
            await http.post(uri, headers: headers, body: jsonEncode(queryBody));
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body); // Giai ma JSON
          if (data["isError"] == false) {
            if (!mounted) return;
            ToastsCustom.showToastSucess(data["message"], context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Hotline(username: widget.userName)));
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
  }

  String getAppoinmentResult() {
    String result = "";
    if (isCheckChuaCoc) {
      var checkChuaCoc =
          listResultCHUACOC.where((item) => item["isChecked"] == true).toList();
      if (checkChuaCoc.isNotEmpty) {
        for (var item in checkChuaCoc) {
          result = "${result + item["Code"]};";
        }
      }
    } else {
      var checkDatCoc =
          listResultDATCOC.where((item) => item["isChecked"] == true).toList();
      if (checkDatCoc.isNotEmpty) {
        for (var item in checkDatCoc) {
          result = "${result + item["Code"]};";
        }
      }
    }

    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 1);
    }
    // den cua hang
    if(isGoToBranch){
      result = "$result,KH_DEN_CH_TT";
    }

    return result;
  }

  bool validateSubmit() {
    List<String> errors = [];
    // chon it nhat 1 ket qua cham soc
    if (getAppoinmentResult().isEmpty) {
      errors.add("Vui lòng chọn ít nhất 1 kết quả chăm sóc");
    }
    // bat buoc nhap noi dung "trao doi voi khach" va "noi dung dat lich"
    var noidungTraodoi = txtTraoDoiVoiKhach.text;
    var noidungDatLich = txtNoiDungDatLich.text;
    if (noidungTraodoi.isEmpty) {
      errors.add("Vui lòng nhập nội dung trao đổi với khách");
    }
    if (noidungDatLich.isEmpty) {
      errors.add("Vui lòng nhập nội dung đặt lịch");
    }

    // kiem tra thoi gian dat lich tiep theo so voi hien tai
    var dateApp = DateFormat("dd/MM/yyyy").format(_selectedDate);
    String timeApp = "$_selectedTime $dateApp";
    DateFormat format = DateFormat("HH:mm dd/MM/yyyy");
    DateTime datetime = format.parse(timeApp);

    var diff = datetime.difference(DateTime.now()).inMinutes;
    if (diff <= 0) {
      errors.add(
          "Thời gian thêm lịch hẹn tiếp theo phải lớn hơn thời gian hiện tại");
    }

    if (errors.isNotEmpty) {
      for (var error in errors) {
        ToastsCustom.showToastWarning(error, context);
      }
      return false;
    } else {
      // gan du lieu
      appresult["MeetingResult"] = getAppoinmentResult();
      appresult["MeetingNote"] = txtTraoDoiVoiKhach.text;

      appoint['ApoinmentNote'] = txtNoiDungDatLich.text;
      appoint['AppointmentDate'] = datetime.toIso8601String();

      return true;
    }
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
          "Kết quả chăm sóc",
          style: TextStyle(
              color: Color.fromARGB(255, 41, 34, 246),
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 183, 183),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: !isCheckChuaCoc,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckChuaCoc = !value!;
                        });
                      },
                    ),
                    const Text(
                      'Đã cọc',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isCheckChuaCoc,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckChuaCoc = value!;
                        });
                      },
                    ),
                    const Text(
                      'Chưa cọc',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isGoToBranch,
                  onChanged: (bool? value) {
                    setState(() {
                      isGoToBranch = value!;
                    });
                  },
                ),
                const Text(
                  'Khách hàng đến trực tiếp cửa hàng',
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 53, 249, 66),
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'Kết quả chăm sóc',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.sizeOf(context).height / 4, // Giới hạn chiều cao
              ),
              child: isCheckChuaCoc
                  ? ListView.builder(
                      itemCount: listResultCHUACOC.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: CheckboxListTile(
                            title: Text(
                              listResultCHUACOC[index]["Name"],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                            value: listResultCHUACOC[index]["isChecked"],
                            onChanged: (bool? value) {
                              setState(() {
                                listResultCHUACOC[index]["isChecked"] = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                            contentPadding: EdgeInsets.zero,
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: listResultDATCOC.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: CheckboxListTile(
                            title: Text(
                              listResultDATCOC[index]["Name"],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                            value: listResultDATCOC[index]["isChecked"],
                            onChanged: (bool? value) {
                              setState(() {
                                listResultDATCOC[index]["isChecked"] = value;
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
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: CustomTextFieldController(
                  name: 'Nội dung trao đổi với khách',
                  controller: txtTraoDoiVoiKhach,
                  readOnly: false),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'THÊM LỊCH CHĂM SÓC KH LẦN TIẾP THEO',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 5,
                        child: DropdownButtonFormField<String>(
                          value: _selectedTime,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTime = newValue;
                            });
                          },
                          items: lstTime.map((String time) {
                            return DropdownMenuItem<String>(
                              value: time,
                              child: Text(
                                time,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
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
                      backgroundColor: const Color.fromARGB(255, 246, 46, 15),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size(50, 40)),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
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
                      backgroundColor: const Color.fromARGB(255, 100, 181, 247),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size(50, 40)),
                  onPressed: () => addAppointmentResult(),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 15),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Thêm mới',
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
    );
  }
}
