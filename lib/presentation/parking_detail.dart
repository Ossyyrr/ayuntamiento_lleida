import 'package:ayuntamiento/core/models/parking.dart';
import 'package:ayuntamiento/core/models/sensor.dart';
import 'package:ayuntamiento/presentation/widgets/progress_bar.dart';
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
            return Text('Something went wrong: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          snapshot.data!.sort((a, b) => a.spot.compareTo(b.spot));
          // % de sensores disponiblesç
          final double availableSensors =
              snapshot.data!.where((sensor) => sensor.available).length /
                  snapshot.data!.length;

          return Column(
            children: [
              ProgressBar(value: availableSensors),
              Expanded(
                child: ListView(
                  children: snapshot.data!
                      .map((sensor) => Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        sensor.available
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: sensor.available
                                            ? Colors.green
                                            : Colors.red,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Spot ${sensor.spot}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    sensor.available ? 'Available' : 'Occupied',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: sensor.available
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
