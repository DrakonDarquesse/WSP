import 'package:app/navigator_middleware.dart';
import 'package:app/provider.dart';
import 'package:app/utils/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/routes.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

NavigatorMiddleware<PageRoute> middleware = NavigatorMiddleware<PageRoute>();

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Worship Service Planner',
      initialRoute: '/adminMemberList',
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
