import 'package:ayuntamiento/core/models/parking.dart';
import 'package:ayuntamiento/core/models/sensor.dart';
import 'package:ayuntamiento/data/services/parking_service.dart';
import 'package:ayuntamiento/presentation/parking_detail.dart';
import 'package:ayuntamiento/presentation/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parkings'),
      ),
      body: StreamBuilder<List<Parking>>(
        stream: parkingsStream,
        builder: (BuildContext context, AsyncSnapshot<List<Parking>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final parking = snapshot.data![index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingDetail(
                      parking: parking,
                    ),
                  ),
                ),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading:
                            const Icon(Icons.local_parking, color: Colors.blue),
                        title: Text(
                          parking.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      StreamBuilder<List<Sensor>>(
                        stream: sensorsStream(parking.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Sensor>> snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          final double availableSensors = snapshot.data!
                                  .where((sensor) => sensor.available)
                                  .length /
                              snapshot.data!.length;

                          return ProgressBar(value: availableSensors);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
