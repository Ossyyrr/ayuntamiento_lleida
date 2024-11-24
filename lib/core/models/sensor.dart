// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Sensor {
  bool available;
  double timestamp;
  String spot;

  Sensor({
    required this.available,
    required this.timestamp,
    required this.spot,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      available: json['available'],
      timestamp: json['timestamp'],
      spot: json['spot'],
    );
  }

  Sensor copyWith({
    bool? available,
    double? timestamp,
    String? spot,
  }) {
    return Sensor(
      available: available ?? this.available,
      timestamp: timestamp ?? this.timestamp,
      spot: spot ?? this.spot,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'available': available,
      'timestamp': timestamp,
      'spot': spot,
    };
  }

  factory Sensor.fromMap(Map<String, dynamic> map) {
    return Sensor(
      available: map['available'] as bool,
      timestamp: map['timestamp'] as double,
      spot: map['spot'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'Sensor(available: $available, timestamp: $timestamp, spot: $spot)';

  @override
  bool operator ==(covariant Sensor other) {
    if (identical(this, other)) return true;

    return other.available == available &&
        other.timestamp == timestamp &&
        other.spot == spot;
  }

  @override
  int get hashCode => available.hashCode ^ timestamp.hashCode ^ spot.hashCode;
}
