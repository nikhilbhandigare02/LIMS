import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_inspector/config/Routes/Route.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:overlay_support/overlay_support.dart';
import 'fcm/bloc/token_bloc.dart';
import 'fcm/repository/token_repository.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_notifier.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? _pendingRoute;
String? _postLoginRoute; // set when we should navigate after a forced login

Future<void> _navigateToResubmitSampleGuarded({required bool fromView}) async {
  try {
    const storage = FlutterSecureStorage();
    final nav = navigatorKey.currentState;
    if (fromView) {
      _postLoginRoute = RouteName.ResubmitSample;
    } else {
      _postLoginRoute = null;
    }

    if (nav != null) {
      await nav.pushNamed(RouteName.loginScreen);

      final String? after = await storage.read(key: 'loginData');
      if ((after != null && after.isNotEmpty) && _postLoginRoute != null) {
        final next = _postLoginRoute!;
        _postLoginRoute = null;
        nav.pushNamed(next);
      }
    } else {
      _pendingRoute = RouteName.loginScreen;
      _postLoginRoute = fromView ? RouteName.ResubmitSample : null;
    }
  } catch (e) {
    print('⚠️ Auth guard navigation error: $e');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('🔔 Background message received: ${message.messageId}');
  _showNotification(message);
}

/// Show system notification (background/terminated)
Future<void> _showNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  final title = notification.title ?? "Notification";
  final body = notification.body ?? "You have a new message";
  final imageUrl = message.data['image'];
  final appName = (message.data['app'] as String?) ?? 'food_inspector';
  final avatarUrl = message.data['avatar'] as String?; // optional for messaging style

  // Prefer a Messaging-style layout when possible to better match the design
  final styleInfo = (avatarUrl != null && avatarUrl.isNotEmpty)
      ? MessagingStyleInformation(
          const Person(name: ' '),
          conversationTitle: title,
          groupConversation: false,
          messages: [
            Message(body, DateTime.now(), const Person(name: ' ')),
          ],
        )
      : ((imageUrl != null && imageUrl.isNotEmpty)
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imageUrl),
              contentTitle: title,
              summaryText: body,
            )
          : BigTextStyleInformation(
              body,
              contentTitle: title,
            ));

  // Use a new channel ID to force Android to apply MAX importance (if an older
  // lower-importance channel existed with the previous ID, Android would keep it).
  final androidDetails = AndroidNotificationDetails(
    'alerts_channel_v2',
    'Alerts & Notifications',
    channelDescription: 'General app alerts and updates',
    importance: Importance.max,
    priority: Priority.max,
    icon: '@mipmap/ic_launcher',
    color: Colors.deepPurple,
    enableVibration: true,
    playSound: true,
    enableLights: true,
    largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    showWhen: true,
    when: DateTime.now().millisecondsSinceEpoch,
    subText: appName,
    category: AndroidNotificationCategory.message,
    colorized: true,
    ticker: title,
    styleInformation: styleInfo,
    visibility: NotificationVisibility.public,
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        'view',
        'View message',
        showsUserInterface: true,
        cancelNotification: true,
      ),
    ],
  );

  final notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    title,
    body,
    notificationDetails,
    payload: (message.data['route'] is String) ? message.data['route'] as String : null,
  );
}

void _showInAppAnimatedMessage(RemoteMessage message) {
  final title = message.notification?.title ?? "Notification";
  final body = message.notification?.body ?? "You have a new message";
  final route = message.data['route'] as String?;

  final context = navigatorKey.currentContext;
  final isDark = context != null && Theme.of(context).brightness == Brightness.dark;

  showOverlayNotification(
    (overlayContext) {
      final Color cardBg = isDark ? const Color(0xFF121212) : Colors.white;
      final Color textPrimary = isDark ? Colors.white : Colors.black87;
      final Color textSecondary = isDark ? Colors.white70 : Colors.black54;
      // final String appName = 'Food ';
      final String timeLabel = '1m';
      final String? avatarUrl = message.data['avatar'] as String?;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GestureDetector(
            onTap: () {
              OverlaySupportEntry.of(overlayContext)!.dismiss();
              if (route != null && route.isNotEmpty) {
                if (route == RouteName.ResubmitSample) {
                  _navigateToResubmitSampleGuarded(fromView: false);
                } else {
                  _navigateFromData({'route': route});
                }
              }
            },
            child: Material(
              color: cardBg,
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App badge
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 12),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header line: app name • time
                          Row(
                            children: [
                              // Text(appName, style: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 6),
                              Text('•', style: TextStyle(color: textSecondary, fontSize: 10)),
                              const SizedBox(width: 6),
                              Text(timeLabel, style: TextStyle(color: textSecondary, fontSize: 10)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Title
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          // Body
                          Text(
                            body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: textSecondary, fontSize: 14, height: 1.25),
                          ),
                          const SizedBox(height: 10),
                          // CTA link
                          InkWell(
                            onTap: () {
                              OverlaySupportEntry.of(overlayContext)!.dismiss();
                              if (route != null && route.isNotEmpty) {
                                if (route == RouteName.ResubmitSample) {
                                  _navigateToResubmitSampleGuarded(fromView: true);
                                } else {
                                  _navigateFromData({'route': route});
                                }
                              }
                            },
                            child: const Text(
                              'View message',
                              style: TextStyle(color: Color(0xFF0F9D58), fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Trailing: avatar + chevron
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: (avatarUrl == null || avatarUrl.isEmpty)
                              ? const Icon(Icons.person, color: Colors.grey, size: 20)
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Icon(Icons.expand_less_rounded, color: textSecondary),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    duration: const Duration(seconds: 5),
    position: NotificationPosition.top,
  );
}

void _navigateFromData(Map<String, dynamic> data) {
  final route = data['route'] as String?;
  if (route != null && route.isNotEmpty) {
    final nav = navigatorKey.currentState;
    if (nav != null) {
      if (route == RouteName.ResubmitSample) {
        _navigateToResubmitSampleGuarded(fromView: false);
      } else {
        nav.pushNamed(route);
      }
    } else {
      _pendingRoute = route;
    }
  } else {
    print('ℹ️ Notification clicked but no route provided in data payload');
  }
}

Future<void> _initFirebaseMessaging(BuildContext context) async {
  final messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission();
  print('🔔 Notification permission status: ${settings.authorizationStatus}');

  final String? token = await messaging.getToken();
  print('🔑 FCM Token: $token');
  if (token != null && token.isNotEmpty) {
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

  // Foreground handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Foreground message received: ${message.messageId}');
    _showInAppAnimatedMessage(message); // 👈 show animated popup
    _showNotification(message); // also trigger system notification
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('➡️ onMessageOpenedApp: navigate without overlay');
    // Navigate directly without showing in-app overlay on reopen
    _navigateFromData(message.data);
  });

  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('🚀 App opened from terminated via notification: navigate without overlay');
    // Navigate directly without showing in-app overlay on cold start
    _navigateFromData(initialMessage.data);
  }

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase Initialized Successfully!');

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload ?? '';
      final actionId = response.actionId;
      if (actionId == 'view') {
        _navigateToResubmitSampleGuarded(fromView: true);
        return;
      }
      if (payload == RouteName.ResubmitSample) {
        _navigateToResubmitSampleGuarded(fromView: false);
        return;
      }
      if (payload.isNotEmpty) {
        navigatorKey.currentState?.pushNamed(payload);
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Clear any stale system notifications from previous sessions to avoid
  // them reappearing when the app restarts.
  await flutterLocalNotificationsPlugin.cancelAll();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    BlocProvider(
      create: (_) => TokenBloc(TokenRepository()),
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  final payload = response.payload ?? '';
  final actionId = response.actionId;
  if (actionId == 'view') {
    _pendingRoute = RouteName.ResubmitSample;
    return;
  }
  if (payload.isNotEmpty) {
    _pendingRoute = payload;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  @override
  void initState() {
    super.initState();
    NoScreenshot.instance.screenshotOff();
    _initFirebaseMessaging(context);
    _loadSavedLocale();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pendingRoute != null && _pendingRoute!.isNotEmpty) {
        final route = _pendingRoute!;
        _pendingRoute = null;
        final nav = navigatorKey.currentState;
        if (nav != null) {
          if (route == RouteName.ResubmitSample) {
            _navigateToResubmitSampleGuarded(fromView: false);
          } else {
            nav.pushNamed(route);
          }
        }
      }
    });
  }

  Future<void> _loadSavedLocale() async {
    try {
      const storage = FlutterSecureStorage();
      final String? lang = await storage.read(key: 'appLanguage');
      if (lang == null || lang.isEmpty) return;
      Locale loc;
      switch (lang.toLowerCase()) {
        case 'hindi':
        case 'hi':
          loc = const Locale('hi');
          break;
        case 'marathi':
        case 'mr':
          loc = const Locale('mr');
          break;
        default:
          loc = const Locale('en');
      }
      if (mounted) setState(() => _locale = loc);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: ValueListenableBuilder<Locale?>(
        valueListenable: appLocale,
        builder: (context, value, _) {
          final effectiveLocale = value ?? _locale;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? 'Food Inspector',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('mr'),
            ],
            locale: effectiveLocale,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            navigatorKey: navigatorKey,
            initialRoute: RouteName.splashScreen,
            onGenerateRoute: Routes.generateRoute,
          );
        },
      ),
    );
  }
}
