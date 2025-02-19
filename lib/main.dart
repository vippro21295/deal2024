import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/firebase_options.dart';
import 'package:flutter_dealxemay_2024/login.dart';
import 'package:flutter_dealxemay_2024/provider/data_provider.dart';
import 'package:flutter_dealxemay_2024/services/notification_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  SharedPreferences pref = await SharedPreferences.getInstance();
  int currentCount = pref.getInt('notification_count') ?? 0;
  pref.setInt('notification_count', currentCount + 1);
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

  //String? token = await firebaseMessaging.getToken() ?? "";
  String token = "";

  await NotificationService.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // luu token
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('token', token);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CountAlert(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    // Kiểm tra số lượng thông báo trong SharedPreferences khi khởi động lại app
    _syncNotificationCountWithProvider(context);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showInstantNotification(
          "${message.notification?.title}", "${message.notification?.body}");

      final countAlertProvider =
          Provider.of<CountAlert>(context, listen: false);
      int countA = countAlertProvider.count + 1;
      countAlertProvider.updateCount(countA);
    });
  }

  Future<void> _syncNotificationCountWithProvider(context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      int notificationCount = pref.getInt('notification_count') ?? 0;
      if (notificationCount > 0) {
        final countAlertProvider =
            Provider.of<CountAlert>(context, listen: false);
        countAlertProvider.updateCount(notificationCount);
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Motor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}
