import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_inspector/config/Routes/Route.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'fcm/bloc/token_bloc.dart';
import 'fcm/repository/token_repository.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('🔔 Background message received: ${message.messageId}');
  _showNotification(message);
}

Future<void> _initFirebaseMessaging(BuildContext context) async {
  final messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission();
  print('🔔 Notification permission status: ${settings.authorizationStatus}');

  final String? token = await messaging.getToken();
  print('🔑 FCM Token: $token');
  if (token != null && token.isNotEmpty) {
    // Only send token if a logged-in user exists
    try {
      const storage = FlutterSecureStorage();
      final String? loginDataJson = await storage.read(key: 'loginData');
      if (loginDataJson != null && loginDataJson.isNotEmpty) {
        context.read<TokenBloc>().add(
              SaveFcmTokenRequested(token: token, platform: 'flutter'),
            );
      } else {
        print('ℹ️ Skipping initial FCM token send: no loginData yet');
      }
    } catch (e) {
      print('⚠️ Error reading secure storage for loginData: $e');
    }
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Foreground message received: ${message.messageId}');
    _showNotification(message);
  });

  // Token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print('🔁 FCM Token refreshed: $newToken');
    if (newToken.isNotEmpty) {
      try {
        const storage = FlutterSecureStorage();
        final String? loginDataJson = await storage.read(key: 'loginData');
        if (loginDataJson != null && loginDataJson.isNotEmpty) {
          context.read<TokenBloc>().add(
                SaveFcmTokenRequested(token: newToken, platform: 'flutter'),
              );
        } else {
          print('ℹ️ Skipping refreshed FCM token send: no loginData yet');
        }
      } catch (e) {
        print('⚠️ Error reading secure storage for loginData (refresh): $e');
      }
    }
  });
}

Future<void> _showNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  const androidDetails = AndroidNotificationDetails(
    'default_channel',
    'General Notifications',
    channelDescription: 'App notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title ?? 'No title',
    notification.body ?? 'No body',
    notificationDetails,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase Initialized Successfully!');

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    BlocProvider(
      create: (_) => TokenBloc(TokenRepository()),
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
    // Initialize FCM with context so we can dispatch Bloc events
    _initFirebaseMessaging(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: RouteName.splashScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
