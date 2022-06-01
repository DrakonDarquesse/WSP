import 'package:app/network/auth.dart';
import 'package:app/provider.dart';
import 'package:app/screens/all.dart';
import 'package:app/utils/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/provider/logout_provider.dart';

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
    if (ref.watch(sessionProvider) == null && !ref.watch(isLogout)) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        String route = ModalRoute.of(context)!.settings.name!;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Loading(route: route),
          ),
        );
      });
    }

    return AppBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(text),
      ),
      backgroundColor: blue(),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
              ref.watch(isLogout.notifier).state = true;
              ref.read(sessionProvider.notifier).clearSession();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Loading(route: '/login'),
                ),
              );
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
