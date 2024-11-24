import 'package:ayuntamiento/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'data/services/firebase_service.dart';
import 'presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Solicita permisos para recibir notificaciones (solo en iOS)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
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
  final parkings = await fetchParkings();
  print(parkings);
  fetchSensorData();

  runApp(const MyApp());
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
      home: const HomeScreen(),
    );
  }
}
