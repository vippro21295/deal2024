import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AppoinmentResult extends StatefulWidget {
  const AppoinmentResult({super.key});

  @override
  State<AppoinmentResult> createState() => _AppoinmentResultState();
}

class _AppoinmentResultState extends State<AppoinmentResult> {
  late List<dynamic> listResultDATCOC = [];
  late List<dynamic> listResultCHUACOC = [];
  bool isChecked = false; // mac dinh la chua coc
  bool isGoToBranch = false;
  DateTime? _selectedDate = DateTime.now();
  String? _selectedTime;
  TextEditingController txtTraoDoiVoiKhach = TextEditingController();
  TextEditingController txtNoiDungDatLich = TextEditingController();
  List<String> lstTime = [];

  @override
  void initState() {
    super.initState();
    getAppointmentResult();
  }

  Future<dynamic> getAppointmentResult() async {
    var uri = Uri.parse('${urlApi}getAppoinmentResult');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var data = body["Lstobj"];
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
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
                      value: !isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = !value!;
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
                  color: const Color.fromARGB(255, 53, 249, 66), borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'Kết quả chăm sóc',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.sizeOf(context).height / 4, // Giới hạn chiều cao
              ),
              child: 
              !isChecked ?
              ListView.builder(
                itemCount: listResultCHUACOC.length,
                itemBuilder: (context, index) {
                  return SizedBox(            
                    width: double.infinity,
                    height: 35,
                    child: CheckboxListTile(
                      title: Text(listResultCHUACOC[index]["Name"], overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13),),
                      value: true,
                      onChanged: (bool? value) {},
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: EdgeInsets.zero,
                    ),
                  );               
                },
              )
              :
              ListView.builder(
                itemCount: listResultDATCOC.length,
                itemBuilder: (context, index) {
                  return SizedBox(            
                    width: double.infinity,
                    height: 35,
                    child: CheckboxListTile(
                      title: Text(listResultDATCOC[index]["Name"], overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13),),
                      value: true,
                      onChanged: (bool? value) {},
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: EdgeInsets.zero,
                    ),
                  );               
                },
              )
              ,
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomTextField(
                name: 'Nội dung trao đổi với khách',
                initValue: '',
                readOnly: false),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'THÊM LỊCH CHĂM SÓC KH LẦN TIẾP THEO',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _selectedDate != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(_selectedDate!)
                                  : 'Chọn ngày',
                              style: const TextStyle(fontSize: 14),
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
                              child: Text(time,  style: const TextStyle(fontSize: 14),),
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
            const CustomTextField(
              name: 'Nội dung đặt lịch',
              initValue: '',
              readOnly: false,
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
                      backgroundColor: const Color.fromARGB(255, 100, 181, 247),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size(50, 40)),
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppoinmentResult()))
                  },
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
