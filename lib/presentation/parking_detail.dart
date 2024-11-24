import 'package:ayuntamiento/core/models/parking.dart';
import 'package:ayuntamiento/core/models/sensor.dart';
import 'package:ayuntamiento/data/services/parking_service.dart';
import 'package:ayuntamiento/presentation/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

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
        stream: sensorsStream(parking.id),
        builder: (BuildContext context, AsyncSnapshot<List<Sensor>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          snapshot.data!.sort((a, b) => a.spot.compareTo(b.spot));

          return Column(
            children: [
              Card(
                  margin: const EdgeInsets.all(24),
                  child: ProgressBar(
                    total: snapshot.data!.length,
                    free: snapshot.data!
                        .where((sensor) => sensor.available)
                        .length,
                  )),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: snapshot.data!
                        .map((sensor) => GestureDetector(
                              // Al hacer tap que lleve a un link de google maps con un marker usando url_launcher, inventa la latitud y longitud
                              // onTap: () => launchUrl(Uri.parse(// Lanza la URL
                              //     'https://www.google.com/maps/search/?api=1')), // Lanza la URL
                              child: Container(
                                width: 150, // Ajusta el tamaño del contenedor
                                height: 150, // Ajusta el tamaño del contenedor
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      const SizedBox(height: 10),
                                      Text(
                                        'Spot ${sensor.spot}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        sensor.available
                                            ? 'Available'
                                            : 'Occupied',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: sensor.available
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
