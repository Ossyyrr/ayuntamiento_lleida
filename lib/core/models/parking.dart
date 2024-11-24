class Parking {
  final String name;
  final String id;
  Parking({
    required this.id,
    required this.name,
  });

  // fromJson() method
  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(name: json['name'], id: json['id']);
  }
}
