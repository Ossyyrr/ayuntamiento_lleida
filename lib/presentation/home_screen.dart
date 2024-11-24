import 'package:ayuntamiento/core/models/parking.dart';
import 'package:ayuntamiento/presentation/parking_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final Stream<List<Parking>> parkingsStream = FirebaseFirestore.instance
    .collection('parkings')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Parking.fromJson(doc.data())).toList());

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
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: const Icon(Icons.local_parking, color: Colors.blue),
                  title: Text(
                    parking.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParkingDetail(
                        parking: parking,
                      ),
                    ),
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
