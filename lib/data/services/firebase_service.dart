import 'package:ayuntamiento/core/models/parking.dart';
import 'package:ayuntamiento/core/models/sensor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Parking>> fetchParkings() async {
  try {
    return await FirebaseFirestore.instance
        .collection("parkings")
        .get()
        .then((event) {
      return event.docs.map((doc) {
        return Parking.fromJson(doc.data());
      }).toList();
    });
  } catch (e) {
    print('Error al obtener las colecciones: $e');
    return [];
  }
}

Future<Sensor?> fetchSensorData() async {
  // Referenciar el documento específico "s1" en la subcolección "sensors"
  final sensorDoc = FirebaseFirestore.instance
      .collection('parkings') // Colección principal
      .doc('p1') // Documento padre
      .collection('sensors') // Subcolección
      .doc('s1'); // Documento específico

  try {
    // Obtener los datos del documento "s1"
    DocumentSnapshot snapshot = await sensorDoc.get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return Sensor.fromJson(data);
    } else {
      print('El documento s1 no existe en sensors.');
      return null;
    }
  } catch (e) {
    print('Error al obtener los datos de s1: $e');
    return null;
  }
}
