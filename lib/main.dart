import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/firebase_options.dart';
import 'package:flutter_dealxemay_2024/login.dart';
import 'package:flutter_dealxemay_2024/services/notification_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  String token = await firebaseMessaging.getToken() ?? "";


  await NotificationService.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MyApp(
    tokenFirebase: token,
  ));
}

class MyApp extends StatefulWidget {
  final String tokenFirebase;
  const MyApp({super.key, required this.tokenFirebase});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {    
      NotificationService.showInstantNotification("${message.notification?.title}", "${message.notification?.body}");
    });

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {   
    return MaterialApp(
      title: 'Notification Motor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(token: widget.tokenFirebase),
      //home: const HomeWiget()
    );
  }
}
