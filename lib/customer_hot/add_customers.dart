import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/customer_hot/add_appoinment_cus.dart';
import 'package:flutter_dealxemay_2024/customer_hot/customer_hot.dart';
import 'package:flutter_dealxemay_2024/models/data_customers.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield.dart';
import 'package:flutter_dealxemay_2024/provider/custom_textfield_controller.dart';
import 'package:flutter_dealxemay_2024/services/common_service.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddCustomers extends StatefulWidget {
  final String username;
  final String type;
  const AddCustomers({super.key, required this.username, required this.type});

  @override
  State<AddCustomers> createState() => _AddCustomersState();
}

class _AddCustomersState extends State<AddCustomers> {
  late Future<dynamic> infoCustomer;
  late DataCustomers dataCus;
  late List<dynamic> listBestModel = [];
  late List<dynamic> listSourceCustomer = [];
  late List<dynamic> listReasonNoInfo = [];
  final dropDownKey = GlobalKey<DropdownSearchState>();
  final dropDownKeySource = GlobalKey<DropdownSearchState>();
  final dropDownKeyNoInfo = GlobalKey<DropdownSearchState>();
  TextEditingController txtExtPhone = TextEditingController();
  TextEditingController txtThoiGian = TextEditingController();
  TextEditingController txtNguonKhachHang = TextEditingController();
  TextEditingController txtHoTen = TextEditingController();
  TextEditingController txtDienThoai = TextEditingController();
  late List<String> lstExtPhone = [];
  String selectedModelMotor = "";
  String selectedSourceCustomer = "5190";
  String selectedReasonNoInfo = "KC";
  String typeCustomer = "H";
  bool isH = true;
  bool isW = false;
  bool isB = false;

  Future<void> getBestModel() async {
    var data = await CommonService.getBestModel();
    setState(() {
      listBestModel = data;
      selectedModelMotor = listBestModel[0]['id'].toString();
    });
  }

  Future<void> getReferenceChannel() async {
    var data = await CommonService.getReferenceChannel();
    setState(() {
      listSourceCustomer = data;
    });
  }

  Future<void> getReasonNoInfo() async {
    var data = await CommonService.getReasonNoInfo();
    setState(() {
      listReasonNoInfo = data;
    });
  }

  Future<void> addCustomerH() async {
    if (validateSubmitH()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddAppoinmentCus(
                  userName: widget.username, objectCus: dataCus)));
    }
  }

  Future<void> addCustomerW() async {
    var queryParameters = {
      'userName': widget.username,
      'reason': selectedReasonNoInfo,
    };

    var uri = Uri.parse('${urlApi}saveCustomerW')
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
                builder: (context) => CustomerHot(username: widget.username)));
      } else {
        ToastsCustom.showToastError(data["message"], context);
      }
    }
  }

  Future<void> addCustomerB() async {
    if (validateSubmitB()) {
      var queryParameters = {
        'userName': widget.username,
        'referenceChannel': selectedSourceCustomer,
        'customerName': txtHoTen.text,
        'phone': txtDienThoai.text,
        'minuteCare': txtThoiGian.text,
        'bestModel': selectedModelMotor
      };

      var uri = Uri.parse('${urlApi}saveCustomerB')
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

  String selectedSourceCus(String id) {
    if (id.isEmpty || listSourceCustomer.isEmpty) {
      return "";
    }

    final selectedItem = listSourceCustomer.firstWhere(
      (item) => item["id"].toString() == id,
    );
    if (selectedItem != null) {
      return "${selectedItem["Name"]}";
    } else {
      return "";
    }
  }

  String selectedNoInfo(String id) {
    if (id.isEmpty || listReasonNoInfo.isEmpty) {
      return "";
    }

    final selectedItem = listReasonNoInfo.firstWhere(
      (item) => item["Code"].toString() == id,
    );
    if (selectedItem != null) {
      return "${selectedItem["Name"]}";
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

  bool validateSubmitH() {
    List<String> errors = [];

    var hoTenKH = txtHoTen.text;
    var dienThoai = txtDienThoai.text;

    if (hoTenKH.isEmpty) {
      errors.add("Vui lòng nhập họ tên khách hàng");
    }

    if (dienThoai.isEmpty) {
      errors.add("Vui lòng nhập SĐT khách hàng");
    } else {
      if ((dienThoai.toString().length == 10 ||
              dienThoai.toString().length == 11) &&
          isNumeric(dienThoai)) {
      } else {
        errors.add("Vui lòng nhập số điện thoại 10 - 11 số");
      }
    }

    if (!isNumeric(txtThoiGian.text)) {    
      errors.add("Vui lòng nhập thời gian chăm sóc là số phút");
      txtThoiGian.text = '0';  
    }

    if (errors.isNotEmpty) {
      for (var error in errors) {
        ToastsCustom.showToastWarning(error, context);
      }
      return false;
    } else {   
      // Create uuid object
      var uuid = const Uuid();
      dataCus = DataCustomers(
        custId: uuid.v4(),
        referenceChannel: int.parse(selectedSourceCustomer),
        fullName: txtHoTen.text,
        phone: txtDienThoai.text,
        extPhone: getExtPhone(),
        interestingLevel: "H",
        email: txtThoiGian.text,
        interestingColors: selectedModelMotor,
        address: "",
        province: 0,
        district: 0,
        contactDate: DateTime.now(),
        ward: 0,
        note:"",
        createdDate:DateTime.now(),
        recivedDealDate: DateTime.now(),
        isCallNow: false,
        isDeleted: false,
        
      );

      return true;
    }
  }

  bool validateSubmitB() {
    List<String> errors = [];

    var hoTenKH = txtHoTen.text;
    var dienThoai = txtDienThoai.text;

    if (hoTenKH.isEmpty) {
      errors.add("Vui lòng nhập họ tên khách hàng");
    }

    if (dienThoai.isEmpty) {
      errors.add("Vui lòng nhập SĐT khách hàng");
    } else {
      if ((dienThoai.toString().length == 10 ||
              dienThoai.toString().length == 11) &&
          isNumeric(dienThoai)) {
      } else {
        errors.add("Vui lòng nhập số điện thoại 10 - 11 số");
      }
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
    infoCustomer = loadInfoCustomer(); // Gọi một hàm async trả về Future
    txtThoiGian.text = "0";
  }

  Future<dynamic> loadInfoCustomer() async {
    await getBestModel(); // Đợi getBestModel hoàn thành
    await getReferenceChannel();
    await getReasonNoInfo();
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
          "Thêm khách hàng",
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
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                height: 50,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: typeCustomer == "H" ? true : false,
                              onChanged: (bool? value) {
                                setState(() {
                                  typeCustomer = "H";
                                });
                              }),
                          const Text(
                            'Có thông tin',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: typeCustomer == "W" ? true : false,
                              onChanged: (bool? value) {
                                setState(() {
                                  typeCustomer = "W";
                                });
                              }),
                          const Text(
                            'Không có thông tin',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: typeCustomer == "B" ? true : false,
                              onChanged: (bool? value) {
                                setState(() {
                                  typeCustomer = "B";
                                });
                              }),
                          const Text(
                            'Đã mua xe',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              typeCustomer == "H"
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: DropdownSearch<String>(
                                key: dropDownKeySource,
                                items: listSourceCustomer
                                    .map((item) => (item["Name"]) as String)
                                    .toList(),
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Nguồn khách hàng (*)",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 15, 113, 174)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                                onChanged: (selectedName) {
                                  // Tìm `id` tương ứng dựa trên `name` đã chọn
                                  final selectedItem =
                                      listSourceCustomer.firstWhere(
                                    (item) => item["Name"] == selectedName,
                                    orElse: () => null,
                                  );
                                  if (selectedItem != null) {
                                    setState(() {
                                      selectedSourceCustomer =
                                          selectedItem["id"].toString();
                                    });
                                  }
                                },
                                selectedItem: selectedSourceCus(
                                  "5190",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CustomTextFieldController(
                                  name: "Họ tên khách hàng: (*)",
                                  controller: txtHoTen,
                                  readOnly: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 6,
                              child: CustomTextFieldController(
                                name: "Điện thoại: (*)",
                                controller: txtDienThoai,
                                readOnly: false,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 242, 111, 74),
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
                                              onTap: () =>
                                                  {deleteExtPhone(index)},
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
                                name: "Ngày tiếp khách hàng: (*)",
                                initValue: DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(
                                        DateTime.now().toIso8601String()))
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
                                    labelText:
                                        "Loại xe - Màu xe quan tâm nhất (*)",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 15, 113, 174)),
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
                                  selectedModelMotor,
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
                                onPressed: () {
                                  Navigator.pop(context);
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
                                    backgroundColor: const Color.fromARGB(
                                        255, 100, 181, 247),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    minimumSize: const Size(50, 40)),
                                onPressed: () => addCustomerH(),
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
                        ),
                      ],
                    )
                  : typeCustomer == "W"
                      ?
                      // khach hang khong co thong tin
                      Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: DropdownSearch<String>(
                                    key: dropDownKeyNoInfo,
                                    items: listReasonNoInfo
                                        .map((item) => (item["Name"]) as String)
                                        .toList(),
                                    dropdownDecoratorProps:
                                        const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Lý do (*)",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 15, 113, 174)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    onChanged: (selectedName) {
                                      // Tìm `id` tương ứng dựa trên `name` đã chọn
                                      final selectedItem =
                                          listReasonNoInfo.firstWhere(
                                        (item) => item["Name"] == selectedName,
                                        orElse: () => null,
                                      );
                                      if (selectedItem != null) {
                                        setState(() {
                                          selectedReasonNoInfo =
                                              selectedItem["Code"].toString();
                                        });
                                      }
                                    },
                                    selectedItem: selectedNoInfo(
                                      "KC",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: CustomTextField(
                                    name: "Ngày tiếp khách hàng: (*)",
                                    initValue: DateFormat('dd/MM/yyyy')
                                        .format(DateTime.parse(
                                            DateTime.now().toIso8601String()))
                                        .toString(),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 246, 46, 15),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        minimumSize: const Size(50, 40)),
                                    onPressed: () {
                                      Navigator.pop(context);
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 100, 181, 247),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        minimumSize: const Size(50, 40)),
                                    onPressed: () => addCustomerW(),
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
                            ),
                          ],
                        )
                      :
                      // da mua xe
                      Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: DropdownSearch<String>(
                                    key: dropDownKeySource,
                                    items: listSourceCustomer
                                        .map((item) => (item["Name"]) as String)
                                        .toList(),
                                    dropdownDecoratorProps:
                                        const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Nguồn khách hàng (*)",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 15, 113, 174)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    onChanged: (selectedName) {
                                      // Tìm `id` tương ứng dựa trên `name` đã chọn
                                      final selectedItem =
                                          listSourceCustomer.firstWhere(
                                        (item) => item["Name"] == selectedName,
                                        orElse: () => null,
                                      );
                                      if (selectedItem != null) {
                                        setState(() {
                                          selectedSourceCustomer =
                                              selectedItem["id"].toString();
                                        });
                                      }
                                    },
                                    selectedItem: selectedSourceCus(
                                      "5190",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: CustomTextFieldController(
                                      name: "Họ tên khách hàng: (*)",
                                      controller: txtHoTen,
                                      readOnly: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: CustomTextFieldController(
                                    name: "Điện thoại: (*)",
                                    controller: txtDienThoai,
                                    readOnly: false,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
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
                                        labelText:
                                            "Loại xe - Màu xe quan tâm nhất (*)",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 15, 113, 174)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    onChanged: (selectedName) {
                                      // Tìm `id` tương ứng dựa trên `name` đã chọn
                                      final selectedItem =
                                          listBestModel.firstWhere(
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
                                      selectedModelMotor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: CustomTextField(
                                    name: "Ngày tiếp khách hàng: (*)",
                                    initValue: DateFormat('dd/MM/yyyy')
                                        .format(DateTime.parse(
                                            DateTime.now().toIso8601String()))
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
                                    name: "Ngày mua:",
                                    initValue: DateFormat('dd/MM/yyyy')
                                        .format(DateTime.now())
                                        .toString(),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 246, 46, 15),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        minimumSize: const Size(50, 40)),
                                    onPressed: () {
                                      Navigator.pop(context);
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 100, 181, 247),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        minimumSize: const Size(50, 40)),
                                    onPressed: () => addCustomerB(),
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
