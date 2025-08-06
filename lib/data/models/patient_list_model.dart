import 'package:flutter/foundation.dart';

class PatientList {
  final bool status;
  final String message;
  final List<Patient> patients;

  PatientList({
    required this.status,
    required this.message,
    required this.patients,
  });

  factory PatientList.fromJson(Map<String, dynamic> json) => PatientList(
    status: json['status'] ?? false,
    message: json['message'] ?? '',
    patients: json['patient'] != null
        ? List<Patient>.from(
        json['patient'].map((x) => Patient.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'patient': patients.map((x) => x.toJson()).toList(),
  };
}

class Patient {
  final int id;
  final List<PatientDetails> patientDetails;
  final Branch? branch;
  final String user;
  final String payment;
  final String name;
  final String phone;
  final String address;
  final dynamic price;
  final int totalAmount;
  final int discountAmount;
  final int advanceAmount;
  final int balanceAmount;
  final DateTime? dateAndTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient({
    required this.id,
    required this.patientDetails,
    required this.branch,
    required this.user,
    required this.payment,
    required this.name,
    required this.phone,
    required this.address,
    required this.price,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateAndTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json['id'],
    patientDetails: json['patientdetails_set'] != null
        ? List<PatientDetails>.from(
        json['patientdetails_set'].map((x) => PatientDetails.fromJson(x)))
        : [],
    branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
    user: json['user'] ?? '',
    payment: json['payment'] ?? '',
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    address: json['address'] ?? '',
    price: json['price'],
    totalAmount: json['total_amount'] ?? 0,
    discountAmount: json['discount_amount'] ?? 0,
    advanceAmount: json['advance_amount'] ?? 0,
    balanceAmount: json['balance_amount'] ?? 0,
    dateAndTime: json['date_nd_time'] != null
        ? DateTime.tryParse(json['date_nd_time'])
        : null,
    isActive: json['is_active'] ?? false,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientdetails_set': patientDetails.map((x) => x.toJson()).toList(),
    'branch': branch?.toJson(),
    'user': user,
    'payment': payment,
    'name': name,
    'phone': phone,
    'address': address,
    'price': price,
    'total_amount': totalAmount,
    'discount_amount': discountAmount,
    'advance_amount': advanceAmount,
    'balance_amount': balanceAmount,
    'date_nd_time': dateAndTime?.toIso8601String(),
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

class Branch {
  final int id;
  final BranchName name;
  final int patientsCount;
  final BranchLocation location;
  final BranchPhone phone;
  final BranchMail mail;
  final BranchAddress address;
  final String gst;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.patientsCount,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json['id'],
    name: BranchNameExtension.fromString(json['name']),
    patientsCount: json['patients_count'] ?? 0,
    location: BranchLocationExtension.fromString(json['location']),
    phone: BranchPhoneExtension.fromString(json['phone']),
    mail: BranchMailExtension.fromString(json['mail']),
    address: BranchAddressExtension.fromString(json['address']),
    gst: json['gst'] ?? '',
    isActive: json['is_active'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name.name,
    'patients_count': patientsCount,
    'location': location.name,
    'phone': phone.name,
    'mail': mail.name,
    'address': address.name,
    'gst': gst,
    'is_active': isActive,
  };
}

class PatientDetails {
  final int id;
  final String male;
  final String female;
  final int patient;
  final int? treatment;
  final String? treatmentName;

  PatientDetails({
    required this.id,
    required this.male,
    required this.female,
    required this.patient,
    this.treatment,
    this.treatmentName,
  });

  factory PatientDetails.fromJson(Map<String, dynamic> json) => PatientDetails(
    id: json['id'],
    male: json['male'] ?? '',
    female: json['female'] ?? '',
    patient: json['patient'],
    treatment: json['treatment'],
    treatmentName: json['treatment_name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'male': male,
    'female': female,
    'patient': patient,
    'treatment': treatment,
    'treatment_name': treatmentName,
  };
}
enum BranchName { EDAPPALI, KUMARAKOM, NADAKKAVU, THONDAYADU }

extension BranchNameExtension on BranchName {
  static BranchName fromString(String value) {
    try {
      return BranchName.values.firstWhere(
              (e) => e.name.toLowerCase() == value.toLowerCase());
    } catch (e) {
      debugPrint("Unknown BranchName: $value");
      return BranchName.EDAPPALI;
    }
  }
}

enum BranchLocation { KOCHI_KERALA, KOZHIKODE, KUMARAKOM }

extension BranchLocationExtension on BranchLocation {
  static BranchLocation fromString(String value) {
    try {
      return BranchLocation.values.firstWhere(
              (e) => e.name.toLowerCase() == value.toLowerCase());
    } catch (e) {
      debugPrint("Unknown BranchLocation: $value");
      return BranchLocation.KOCHI_KERALA;
    }
  }
}

enum BranchPhone {
  THE_9846123456,
  THE_9946331452,
  THE_99463314529747331452
}

extension BranchPhoneExtension on BranchPhone {
  static BranchPhone fromString(String value) {
    try {
      return BranchPhone.values.firstWhere(
              (e) => e.name.toLowerCase() == value.toLowerCase());
    } catch (e) {
      debugPrint("Unknown BranchPhone: $value");
      return BranchPhone.THE_9846123456;
    }
  }
}

enum BranchMail { USER123_GMAIL_COM, USER123_GMAIL_COMM }

extension BranchMailExtension on BranchMail {
  static BranchMail fromString(String value) {
    try {
      return BranchMail.values.firstWhere(
              (e) => e.name.toLowerCase() == value.toLowerCase());
    } catch (e) {
      debugPrint("Unknown BranchMail: $value");
      return BranchMail.USER123_GMAIL_COM;
    }
  }
}

enum BranchAddress {
  KOCHI_KERALA_685565,
  KOTTAYAM_KERALA_6865636,
  KOZHIKODE
}

extension BranchAddressExtension on BranchAddress {
  static BranchAddress fromString(String value) {
    try {
      return BranchAddress.values.firstWhere(
              (e) => e.name.toLowerCase() == value.toLowerCase());
    } catch (e) {
      debugPrint("Unknown BranchAddress: $value");
      return BranchAddress.KOCHI_KERALA_685565;
    }
  }
}
