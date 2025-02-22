//students Data Fetching model class
// ignore_for_file: non_constant_identifier_names

class Api {
  final String institution;
  final String name;
  final int dob;
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

  // Factory constructor to create an instance from JSON
  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(
      institution: json['institution'] ?? 'N/A',
      name: json['name'] ?? 'N/A',
      dob: json['dob'] ?? 'N/A',
      studentId: json['studentId'] ?? 'N/A',
      activestatus: json['activestatus'] ?? 'N/A',
      course: json['course'] ?? 'N/A',
      degreetype: json['degreetype'] ?? 'N/A',
      sch: json['sch'] ?? 'N/A',
      fg: json['fg'] ?? 'N/A',
      postmetric: json['postmetric'] ?? 'N/A',
      department: json['department'] ?? 'N/A',
      batch: json['batch'] ?? 'N/A',
      active: json['active'] ?? 'N/A',
    );
  }
}

//fees details fetching model class
class FeesData {
  final String term;
  final int amount;
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
      term: json['term'] ?? "N/A",
      amount: json['amount'] ?? "N/A",
      dueDate: json['dueDate'] ?? "N/A",
      duration: json['duration'] ?? "N/A",
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
      type: json['type'],
      amount: (json['amount'] as num).toDouble(), // Ensure it's a double
      dueDate: json['dueDate'],
      duration: json['duration'],
    );
  }
}
