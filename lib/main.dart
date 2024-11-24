import 'package:ayuntamiento/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Solicita permisos para recibir notificaciones (solo en iOS)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Obtén el token APNS (solo en iOS)
  String? apnsToken = await messaging.getAPNSToken();
  print("APNS Token: $apnsToken");

  // Obtén el token para las notificaciones push
  String? token = await messaging.getToken();
  print("Token de notificaciones push: $token");

  // Accede a todas las colecciones en Cloud Firestore
  fetchSensorData();

  runApp(const MyApp());
}

void fetchSensorData() async {
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
      print('Datos de s1: ${snapshot.data()}');
    } else {
      print('El documento s1 no existe en sensors.');
    }
  } catch (e) {
    print('Error al obtener los datos de s1: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}
