import 'package:app/network/auth.dart';
import 'package:app/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class Loading extends ConsumerWidget {
  final String route;

  const Loading({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    print(ref.watch(sessionProvider));
    print(route);
    if (ref.watch(sessionProvider) != null) {
      print('objectaa');
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(route);
      });
    }

    if (ref.watch(sessionProvider) == null && route == '/login') {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
