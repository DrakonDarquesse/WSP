import 'package:app/models/member.dart';
import 'package:app/provider.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/size.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Member? member = ref.watch(sessionProvider);
    return Scaffold(
      appBar: const CustomAppBar(text: 'Profile'),
      body: Center(
        child: member == null
            ? const CircularProgressIndicator()
            : Container(
                child: Column(
                  children: [
                    TextWidget(text: [
                      TextSpan(
                          text: member.name,
                          style: Theme.of(context).textTheme.headline5),
                    ]),
                    TextWidget(text: [
                      TextSpan(text: member.email),
                    ]),
                    TextWidget(
                      text: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              member.isActive
                                  ? Icons.notifications_outlined
                                  : Icons.notifications_off_outlined,
                              size: 20,
                              color: member.isActive ? safe() : red(),
                            ),
                          ),
                          alignment: PlaceholderAlignment.top,
                        ),
                        TextSpan(
                          text: member.getIsActive(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: member.roles.isNotEmpty
                          ? Wrap(
                              children: member.roles.map<Chip>((role) {
                                return Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor: role.color,
                                    child: Text(
                                      role.name[0].toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  label: Text(role.name),
                                  backgroundColor: role.color.withOpacity(0.15),
                                );
                              }).toList(),
                              runSpacing: 8,
                              spacing: 10,
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                    ButtonWidget(
                      text: 'Edit role',
                      callback: () {
                        ref.watch(modeProvider.notifier).state = Mode.edit;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditDialogWidget(
                              text: 'Edit',
                              model: member,
                            );
                          },
                        );
                      },
                    )
                  ],
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
                width: isMobile(context)
                    ? percentWidth(context, 0.8)
                    : percentWidth(context, 0.4),
                padding: const EdgeInsets.all(30),
                color: Colors.white,
              ),
      ),
      backgroundColor: lightBlue(),
    );
  }
}
