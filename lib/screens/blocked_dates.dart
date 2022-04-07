import 'package:app/models/member.dart';
import 'package:app/network/member.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/member_roster.dart';
import 'package:app/utils/size.dart';
import 'package:app/widgets/add_dialog_widget.dart';
import 'package:app/widgets/button_widget.dart';
import 'package:app/widgets/list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockedDates extends ConsumerWidget {
  const BlockedDates({
    Key? key,
  }) : super(key: key);

  final IconData icon = Icons.event_busy;
  final List<Map> list = const [];
  @override
  Widget build(BuildContext context, ref) {
    final Member? member = ref.watch(sessionProvider);
    if (member == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight:
                  percentHeight(context, isMobile(context) ? 0.65 : 0.75)),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTileWidget(
                dateTime: member.blockedDates[index].date,
                event: member.blockedDates[index].note,
                icon: icon,
                trailing: [
                  {
                    'text': 'Delete',
                    'onPressed': () async {
                      member.blockedDates.removeAt(index);
                      Member newMember = Member(
                        id: member.id,
                        email: member.email,
                        name: member.name,
                        roles: member.roles,
                        blockedDates: member.blockedDates,
                      );

                      await editMember(newMember).then((value) {
                        ref.read(sessionProvider.notifier).getMember();
                        ref.read(memberListProvider.notifier).load();
                      });
                    },
                  },
                  {
                    'text': 'Edit',
                    'onPressed': () {},
                  },
                ],
              );
            },
            itemCount: member.blockedDates.length,
          ),
        ),
        ButtonWidget(
          text: 'Add Blocked Date',
          callback: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddDialogWidget(
                  text: 'Add Blocked Date',
                );
              },
            );
          },
          color: lightBlue(),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
