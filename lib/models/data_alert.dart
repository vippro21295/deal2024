class DataAlert {
  late final String messageStatus;
  late final String message;
  late final String createdDate;
  DataAlert(
      {required this.messageStatus,
      required this.message,
      required this.createdDate});

  // Phương thức từ JSON chuyển đổi thành đối tượng DataObject
  factory DataAlert.fromJson(Map<String, dynamic> json) {
    return DataAlert(
        messageStatus: json['messageStatus'] as String,
        message: json['message'] as String,
        createdDate: json['createdDate'] as String);
  }
}
