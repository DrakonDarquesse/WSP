import 'package:app/navigator_middleware.dart';
import 'package:app/provider.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/routes.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      initialRoute: '/roster',
      routes: routes,
      theme: ThemeData(
        primaryColor: lightBlue(),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: black(),
              displayColor: black(),
            ),
      ),
      navigatorObservers: [middleware],
    );
  }
}
