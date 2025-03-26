class LineItem {
  String purchasableType;
  int? purchaseId;
  int quantity;
  double price;
  double total;

  LineItem({
    required this.purchasableType,
    this.purchaseId,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      purchasableType: json['purchasable_type'],
      purchaseId: json['purchase_id'],
      quantity: json['quantity'],
      price: json['price'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchasable_type': purchasableType,
      'purchase_id': purchaseId,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }
}
