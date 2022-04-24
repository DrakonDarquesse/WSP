import 'package:app/network/auth.dart';
import 'package:app/provider.dart';
import 'package:app/utils/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String text;
  final PreferredSizeWidget? tab;
  final bool backable;
  const CustomAppBar({
    Key? key,
    required this.text,
    this.tab,
    this.backable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    if (!ref.watch(sessionProvider.notifier).signedIn) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed("/login");
      });
    }
    return AppBar(
      title: Text(text),
      backgroundColor: blue(),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
              ref.read(sessionProvider.notifier).clearSession();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            tooltip: 'Logout',
          ),
        ),
      ],
      bottom: tab,
      automaticallyImplyLeading: backable,
    );
  }

  @override
  Size get preferredSize =>
      tab != null ? const Size.fromHeight(80) : AppBar().preferredSize;
}
