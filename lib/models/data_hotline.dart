
class DataHotline {
  late final String custID;
  late final String fullName;
  late final String phone;
  late final String note;
  late final String recivedDealDate;
  late final String createdDate;
  late final String referenChannelName;
  late final String? interestingColorsName;
  late final String? appointmentResult;
  late final String lichSuChuyenDeal;
  late final String interestingLevel;
  late final bool isRecived;
  late final String status;
  DataHotline({
    required this.custID,
    required this.fullName,
    required this.phone,
    required this.note,
    required this.recivedDealDate,
    required this.createdDate,
    required this.referenChannelName,
    required this.interestingColorsName,
    required this.appointmentResult,
    required this.lichSuChuyenDeal,
    required this.interestingLevel,
    required this.isRecived,
    required this.status,
  });

  // Phương thức từ JSON chuyển đổi thành đối tượng DataObject
  factory DataHotline.fromJson(Map<String, dynamic> json) {
    return DataHotline(
        custID: json['CustID'] as String,
        fullName: json['FullName'] as String,
        phone: json['Phone'] as String,
        note: json['Note'] as String,
        recivedDealDate: json['RecivedDealDate'] as String,
        createdDate: json['CreatedDate'] as String,
        referenChannelName: json['ReferenceChannelName'] as String,
        interestingColorsName: json['InterestingColorsName'] as String? ?? '',
        appointmentResult: json['AppointmentResult'] as String? ?? '',
        lichSuChuyenDeal: json['LichSuChuyenDeal'] as String,
        interestingLevel: json['InterestingLevel'] as String,
        isRecived: json['IsRecived'] as bool,
        status: json['StatusName'] as String);
  }
}
