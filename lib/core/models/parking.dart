class Parking {
  final String name;
  Parking({
    required this.name,
  });

  // fromJson() method
  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(name: json['name']);
  }
}
