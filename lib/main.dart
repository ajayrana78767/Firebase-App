// ignore_for_file: avoid_print, unused_local_variable
import 'dart:async';
import 'package:firebase_app/firebase_options.dart';
import 'package:firebase_app/notifications_services.dart';
//import 'package:firebase_app/ui/auth/firestore/firestore_list_screen.dart';
import 'package:firebase_app/ui/auth/login_screen.dart';
import 'package:firebase_app/ui/auth/posts/posts_screen.dart';
import 'package:firebase_app/ui/provider/google_sign_in.dart';
//import 'package:firebase_app/ui/auth/upload_image.dart';
//import 'package:firebase_app/ui/auth/posts/posts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Set up and activate the AppCheckProvider for each platform

  await FirebaseAppCheck.instance.activate();

  runApp(const MyApp());
}

//@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print(message.notification!.title.toString());
  print('hello');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GoogleSignInProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NotificationsServices notificationsServices = NotificationsServices();
  @override
  void initState() {
    super.initState();
    notificationsServices.requestNotificationPermission();
    notificationsServices.firebaseInit();
    //notificationsServices.isTokenRefresh();
    notificationsServices.getDeviceToken().then((value) => {
          print("device token"),
          print(value),
        });

    // check user is alreday login or not
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
        const Duration(seconds: 2), // Change the duration as needed
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PostScreen()), // Replace MyApp() with your main app widget
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 2), // Change the duration as needed
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen()), // Replace MyApp() with your main app widget
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Hello!",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
