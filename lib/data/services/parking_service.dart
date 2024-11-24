import 'package:ayuntamiento/core/models/parking.dart';
import 'package:ayuntamiento/core/models/sensor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<Sensor>> sensorsStream(String parkingId) {
  return FirebaseFirestore.instance
      .collection('parkings')
      .doc(parkingId)
      .collection('sensors')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Sensor.fromJson(doc.data())).toList());
}

final Stream<List<Parking>> parkingsStream = FirebaseFirestore.instance
    .collection('parkings')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Parking.fromJson(doc.data())).toList());
