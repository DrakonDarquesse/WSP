import 'package:app/navigator_middleware.dart';
import 'package:app/network/message.dart';
import 'package:app/provider.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {}
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    token();
  }

  @override
  Widget build(BuildContext context) {
    NavigatorMiddleware<PageRoute> middleware =
        NavigatorMiddleware<PageRoute>((route) {
      if (route.settings.name == '/role') {
        ref.read(modelProvider.notifier).state = Model.role;
      }
      if (route.settings.name == '/member') {
        ref.read(modelProvider.notifier).state = Model.member;
      }

      if (route.settings.name == '/roster') {
        ref.read(modelProvider.notifier).state = Model.roster;
      }

      if (route.settings.name == '/memberSchedule') {
        ref.read(modelProvider.notifier).state = Model.blockedDate;
      }
    });

    return MaterialApp(
      title: 'Worship Service Planner',
      initialRoute: '/login',
      routes: routes,
      theme: ThemeData(
        primaryColor: lightBlue(),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: black(),
              displayColor: black(),
            ),
      ),
      navigatorObservers: [middleware],
      debugShowCheckedModeBanner: false,
    );
  }
}
