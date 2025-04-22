class PaymentHistory {
  final String id;
  final String studentId;
  final double amount;
  final String paymentDate;
  final String paymentMethod;
  final String status;
  final String? transactionId;
  final String? description;

  PaymentHistory({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    this.description,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['_id'] as String,
      studentId: json['studentId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: json['paymentDate'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'amount': amount,
      'paymentDate': paymentDate,
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionId': transactionId,
      'description': description,
    };
  }
}
