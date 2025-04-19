//students Data Fetching model class
// ignore_for_file: non_constant_identifier_names

class Api {
  final String institution;
  final String name;
  final String dob; // Changed to String since it's likely a date string
  final String studentId;
  final String activestatus;
  final String course;
  final String degreetype;
  final String sch;
  final String fg;
  final String postmetric;
  final String department;
  final String batch;
  final String active;

  Api({
    required this.institution,
    required this.name,
    required this.dob,
    required this.studentId,
    required this.activestatus,
    required this.course,
    required this.degreetype,
    required this.sch,
    required this.fg,
    required this.postmetric,
    required this.department,
    required this.batch,
    required this.active,
  });

  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(
      institution: json['institution']?.toString() ?? 'N/A',
      name: json['name']?.toString() ?? 'N/A',
      dob: json['dob']?.toString() ?? 'N/A',
      studentId: json['studentId']?.toString() ?? 'N/A',
      activestatus: json['activestatus']?.toString() ?? 'N/A',
      course: json['course']?.toString() ?? 'N/A',
      degreetype: json['degreetype']?.toString() ?? 'N/A',
      sch: json['sch']?.toString() ?? 'N/A',
      fg: json['fg']?.toString() ?? 'N/A',
      postmetric: json['postmetric']?.toString() ?? 'N/A',
      department: json['department']?.toString() ?? 'N/A',
      batch: json['batch']?.toString() ?? 'N/A',
      active: json['active']?.toString() ?? 'N/A',
    );
  }
}

//fees details fetching model class
class FeesData {
  final String term;
  final double amount; // Changed to double for better precision
  final String dueDate;
  final String duration;

  FeesData({
    required this.term,
    required this.amount,
    required this.dueDate,
    required this.duration,
  });

  factory FeesData.fromJson(Map<String, dynamic> json) {
    return FeesData(
      term: json['term']?.toString() ?? 'N/A',
      amount: (json['amount'] ?? 0).toDouble(),
      dueDate: json['dueDate']?.toString() ?? 'N/A',
      duration: json['duration']?.toString() ?? 'N/A',
    );
  }
}

class Payment {
  final double paidAmount;
  final String date;
  final String referenceNo;

  Payment({
    required this.paidAmount,
    required this.date,
    required this.referenceNo,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      date: json['date']?.toString() ?? 'N/A',
      referenceNo: json['referenceNo']?.toString() ?? 'N/A',
    );
  }
}

// Additional Fees Data model class
class AdditionalFeeData {
  final String type;
  final double amount;
  final String dueDate;
  final String duration;

  AdditionalFeeData({
    required this.type,
    required this.amount,
    required this.dueDate,
    required this.duration,
  });

  factory AdditionalFeeData.fromJson(Map<String, dynamic> json) {
    return AdditionalFeeData(
      type: json['type']?.toString() ?? 'N/A',
      amount: (json['amount'] ?? 0).toDouble(),
      dueDate: json['dueDate']?.toString() ?? 'N/A',
      duration: json['duration']?.toString() ?? 'N/A',
    );
  }
}

class PaymentHistory {
  final String type;
  final String dueDate;
  final String duration;
  final double amount;

  PaymentHistory({
    required this.type,
    required this.dueDate,
    required this.duration,
    required this.amount,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      type: json['type']?.toString() ?? 'Unknown',
      dueDate: json['dueDate']?.toString() ?? 'N/A',
      duration: json['duration']?.toString() ?? 'N/A',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class Recipt {
  final String name;
  final String departement;
  final String batch;
  final String regno;
  final String feestype;
  final String date;
  final double totalamount;
  final double paidamount;
  final double balanceamount;
  final String referenceno;

  Recipt({
    required this.name,
    required this.departement,
    required this.batch,
    required this.regno,
    required this.feestype,
    required this.date,
    required this.totalamount,
    required this.paidamount,
    required this.balanceamount,
    required this.referenceno,
  });

  factory Recipt.fromJson(Map<String, dynamic> json) {
    return Recipt(
      name: json['name']?.toString() ?? 'Unknown',
      departement: json['departement']?.toString() ?? 'Unknown',
      batch: json['batch']?.toString() ?? 'Unknown',
      regno: json['regno']?.toString() ?? 'Unknown',
      feestype: json['feestype']?.toString() ?? 'Unknown',
      date: json['date']?.toString() ?? 'Unknown',
      totalamount: (json['totalamount'] ?? 0).toDouble(),
      paidamount: (json['paidamount'] ?? 0).toDouble(),
      balanceamount: (json['balanceamount'] ?? 0).toDouble(),
      referenceno: json['referenceno']?.toString() ?? 'Unknown',
    );
  }
}
