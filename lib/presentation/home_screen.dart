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
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!
                .map((parking) => ListTile(
                    title: Text(parking.name),
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingDetail(
                                    parking: parking,
                                  )),
                        )))
                .toList(),
          );
        },
      ),
    );
  }
}
