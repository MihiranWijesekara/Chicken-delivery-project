class ItemModel{
  final int? id;
  final String name;
  final double price;

ItemModel({
  this.id,
  required this.name,
  required this.price,
});

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'name': name,
    'price': price,
  };
}
factory ItemModel.fromMap(Map<String, dynamic> map) {
  return ItemModel(
    id: map['id'],
    name: map['name'],
    price: map['price'],
  );
}

}