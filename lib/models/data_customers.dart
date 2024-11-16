class DataCustomers {
  late final String custID;
  late final String fullName;
  late final String address;
  late final String phone;
  late final String extPhone;
  late final String email;
  late final int province;
  late final int district;
  late final int referenceChannel;
  DataCustomers(
      {
      required this.custID,
      required this.fullName,
      required this.address,
      required this.phone,
      required this.extPhone,
      required this.email,
      required this.province,
      required this.district,
      required this.referenceChannel
      });

  // Phương thức từ JSON chuyển đổi thành đối tượng DataObject
  factory DataCustomers.fromJson(Map<String, dynamic> json) {
    return DataCustomers(
        custID: json['CustID'] as String,
        fullName: json['FullName'] as String,
        address: json['Address'] as String? ?? '',
        phone: json['Phone'] as String,
        extPhone: json['ExtPhone'] as String? ?? '',
        email: json['Email'] as String? ?? '',
        province: json['Province'] as int? ?? 0,
        district: json['District'] as int? ?? 0,
        referenceChannel: json['ReferenceChannel'] as int
        );
  }
}
