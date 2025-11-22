class TransactionModel {
  final int? id;
  final String username;
  final String medicineName;
  final int price;
  final int quantity;
  final int totalPrice;
  final String date;
  final String type;
  final String? recipeNumber;

  TransactionModel({
    this.id,
    required this.username,
    required this.medicineName,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.date,
    required this.type,
    this.recipeNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'medicineName': medicineName,
      'price': price,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'date': date,
      'type': type,
      'recipeNumber': recipeNumber,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      username: map['username'],
      medicineName: map['medicineName'],
      price: map['price'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      date: map['date'],
      type: map['type'],
      recipeNumber: map['recipeNumber'],
    );
  }
}
