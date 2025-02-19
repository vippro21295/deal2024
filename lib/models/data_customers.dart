class DataCustomers {
    DataCustomers({
         this.referenceChannelName,
         this.custId,
         this.fullName,
         this.address,
         this.phone,
         this.extPhone,
         this.email,
         this.province,
         this.district,
         this.contactDate,
         this.ward,
         this.statusLevel,
         this.interestingLevel,
         this.referenceChannel,
         this.paymentType,
         this.loanLimit,
         this.bankAdvice,
         this.currentAuto,
         this.interestingModels,
         this.interestingColors,
         this.note,
         this.denyReason,
         this.denyNote,
         this.appointmentResult,
         this.cr,
         this.status,
         this.originalInfo,
         this.isCallNow,
         this.createdBy,
         this.createdDate,
         this.recivedDealDate,
         this.updatedBy,
         this.updatedDate,
         this.isDeleted,
         this.deletedBy,
         this.deletedDate,
         this.systemNote,
         this.reasonNoInfo,
         this.buyDate,
         this.isSendSms,
         this.sendDate,
         this.store,
         this.isRecived,
         this.reciveDate,
         this.remindBy,
         this.districtName,
         this.code,
         this.isGotoBranch,
         this.dateGotoBranch,
         this.maPhieuBl,
         this.createdByCr,
    });

    late String? referenceChannelName;
    late String? custId;
    late String? fullName;
    late String? address;
    late String? phone;
    late String? extPhone;
    late String? email;
    late int? province;
    late int? district;
    late DateTime? contactDate;
    late int? ward;
    late dynamic statusLevel;
    late String? interestingLevel;
    late int? referenceChannel;
    late String? paymentType;
    late dynamic loanLimit;
    late dynamic bankAdvice;
    late dynamic currentAuto;
    late String? interestingModels;
    late String? interestingColors;
    late String? note;
    late String? denyReason;
    late String? denyNote;
    late dynamic appointmentResult;
    late String? cr;
    late String? status;
    late String? originalInfo;
    late bool? isCallNow;
    late String? createdBy;
    late DateTime? createdDate;
    late DateTime? recivedDealDate;
    late String? updatedBy;
    late DateTime? updatedDate;
    late bool? isDeleted;
    late String? deletedBy;
    late dynamic deletedDate;
    late String? systemNote;
    late String? reasonNoInfo;
    late dynamic buyDate;
    late bool? isSendSms;
    late dynamic sendDate;
    late String? store;
    late bool? isRecived;
    late DateTime? reciveDate;
    late String? remindBy;
    late String? districtName;
    late dynamic code;
    late dynamic isGotoBranch;
    late dynamic dateGotoBranch;
    late dynamic maPhieuBl;
    late String? createdByCr;

    factory DataCustomers.fromJson(Map<String, dynamic> json){ 
        return DataCustomers(
            referenceChannelName: json["ReferenceChannelName"],
            custId: json["CustID"],
            fullName: json["FullName"],
            address: json["Address"],
            phone: json["Phone"],
            extPhone: json["ExtPhone"],
            email: json["Email"],
            province: json["Province"],
            district: json["District"],
            contactDate: DateTime.tryParse(json["ContactDate"] ?? ""),
            ward: json["Ward"],
            statusLevel: json["StatusLevel"],
            interestingLevel: json["InterestingLevel"],
            referenceChannel: json["ReferenceChannel"],
            paymentType: json["PaymentType"],
            loanLimit: json["LoanLimit"],
            bankAdvice: json["BankAdvice"],
            currentAuto: json["CurrentAuto"],
            interestingModels: json["InterestingModels"],
            interestingColors: json["InterestingColors"],
            note: json["Note"],
            denyReason: json["DenyReason"],
            denyNote: json["DenyNote"],
            appointmentResult: json["AppointmentResult"],
            cr: json["CR"],
            status: json["Status"],
            originalInfo: json["OriginalInfo"],
            isCallNow: json["IsCallNow"],
            createdBy: json["CreatedBy"],
            createdDate: DateTime.tryParse(json["CreatedDate"] ?? ""),
            recivedDealDate: DateTime.tryParse(json["RecivedDealDate"] ?? ""),
            updatedBy: json["UpdatedBy"],
            updatedDate: DateTime.tryParse(json["UpdatedDate"] ?? ""),
            isDeleted: json["IsDeleted"],
            deletedBy: json["DeletedBy"],
            deletedDate: json["DeletedDate"],
            systemNote: json["SystemNote"],
            reasonNoInfo: json["ReasonNoInfo"],
            buyDate: json["BuyDate"],
            isSendSms: json["IsSendSMS"],
            sendDate: json["SendDate"],
            store: json["Store"],
            isRecived: json["IsRecived"],
            reciveDate: DateTime.tryParse(json["ReciveDate"] ?? ""),
            remindBy: json["RemindBy"],
            districtName: json["DistrictName"],
            code: json["Code"],
            isGotoBranch: json["IsGotoBranch"],
            dateGotoBranch: json["DateGotoBranch"],
            maPhieuBl: json["MaPhieuBL"],
            createdByCr: json["CreatedByCR"],
        );
    }

    Map<String, dynamic> toJson() => {
        "ReferenceChannelName": referenceChannelName,
        "CustID": custId,
        "FullName": fullName,
        "Address": address,
        "Phone": phone,
        "ExtPhone": extPhone,
        "Email": email,
        "Province": province,
        "District": district,
        "ContactDate": contactDate?.toIso8601String(),
        "Ward": ward,
        "StatusLevel": statusLevel,
        "InterestingLevel": interestingLevel,
        "ReferenceChannel": referenceChannel,
        "PaymentType": paymentType,
        "LoanLimit": loanLimit,
        "BankAdvice": bankAdvice,
        "CurrentAuto": currentAuto,
        "InterestingModels": interestingModels,
        "InterestingColors": interestingColors,
        "Note": note,
        "DenyReason": denyReason,
        "DenyNote": denyNote,
        "AppointmentResult": appointmentResult,
        "CR": cr,
        "Status": status,
        "OriginalInfo": originalInfo,
        "IsCallNow": isCallNow,
        "CreatedBy": createdBy,
        "CreatedDate": createdDate?.toIso8601String(),
        "RecivedDealDate": recivedDealDate?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedDate": updatedDate?.toIso8601String(),
        "IsDeleted": isDeleted,
        "DeletedBy": deletedBy,
        "DeletedDate": deletedDate,
        "SystemNote": systemNote,
        "ReasonNoInfo": reasonNoInfo,
        "BuyDate": buyDate,
        "IsSendSMS": isSendSms,
        "SendDate": sendDate,
        "Store": store,
        "IsRecived": isRecived,
        "ReciveDate": reciveDate?.toIso8601String(),
        "RemindBy": remindBy,
        "DistrictName": districtName,
        "Code": code,
        "IsGotoBranch": isGotoBranch,
        "DateGotoBranch": dateGotoBranch,
        "MaPhieuBL": maPhieuBl,
        "CreatedByCR": createdByCr,
      };


}
