class Salesmodel {
  final int? id;
  final String billNo;
  final int? shopId;
  final int itemId;
  final int sellingPrice;
  final int? quantityKg;
  final double? amount;
  final String? vatNumber;
  final String? addedDate;
  final String? shopName;
  final int? qty;

  Salesmodel({
    this.id,
    required this.billNo,
    this.shopId,
    required this.itemId,
    required this.sellingPrice,
    this.quantityKg,
    this.amount,
    this.vatNumber,
    this.addedDate,
    this.shopName,
    this.qty,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bill_no': billNo,
      'shop_id': shopId,
      'item_id': itemId,
      'selling_price': sellingPrice,
      'quantity_grams': quantityKg,
      'amount': amount,
      'Vat_Number': vatNumber,
      'added_date': addedDate,
      'QTY': qty,
    };
  }

  // Create from Map
  factory Salesmodel.fromMap(Map<String, dynamic> map) {
    return Salesmodel(
      id: map['id'],
      billNo: map['bill_no'],
      shopId: map['shop_id'],
      itemId: map['item_id'],
      sellingPrice: map['selling_price'],
      quantityKg: map['quantity_grams'],
      amount: map['amount'],
      vatNumber: map['Vat_Number'],
      addedDate: map['added_date'],
      shopName: map['shop_name'],
      qty: map['QTY'],
    );
  }
}
