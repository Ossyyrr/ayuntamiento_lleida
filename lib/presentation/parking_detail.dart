import 'package:ayuntamiento/core/models/parking.dart';
import 'package:ayuntamiento/core/models/sensor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final Stream<List<Sensor>> parkingsStream = FirebaseFirestore.instance
    .collection('parkings') // Colección principal
    .doc('p1') // Documento padre
    .collection('sensors')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Sensor.fromJson(doc.data())).toList());

class ParkingDetail extends StatelessWidget {
  const ParkingDetail({
    super.key,
    required this.parking,
  });
  final Parking parking;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors'),
      ),
      body: StreamBuilder<List<Sensor>>(
        stream: parkingsStream,
        builder: (BuildContext context, AsyncSnapshot<List<Sensor>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!
                .map((sensor) => ListTile(
                      title: Text(sensor.spot),
                      subtitle:
                          Text(sensor.available ? 'Available' : 'Occupied'),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
