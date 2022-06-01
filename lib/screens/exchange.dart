import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/provider.dart';
import 'package:app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExchangeDialog extends ConsumerWidget {
  final Map<String, dynamic> toBeExchanged;
  const ExchangeDialog({
    Key? key,
    required this.toBeExchanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Role theRole = toBeExchanged['roleMember'].role;
    Member theMember = toBeExchanged['roleMember'].member;

    List<Widget> list = ref
        .watch(rosterListProvider)
        .where((e) => e.date.isAfter(DateTime.now()))
        .fold<List<Map<String, dynamic>>>([], (a, b) {
      List<Map<String, dynamic>> rm = b.roleMembers
          .where((e) => e.role == theRole)
          .where((e) => e.status == Status.accepted)
          .where((e) => e.member.name != '' && e.member != theMember)
          .map<Map<String, dynamic>>(
              (e) => {'id': b.id, 'date': b.date, 'roleMember': e})
          .toList();
      if (rm.isNotEmpty) {
        a.addAll(rm);
      }
      return a;
    }).map<SimpleDialogOption>((e) {
      return SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, e);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: [
                TextSpan(
                    text: DateFormat('yMd').format(e['date']),
                    style: Theme.of(context).textTheme.headline6),
              ],
              compact: true,
            ),
            Text(e['roleMember'].member.name),
          ],
        ),
      );
    }).toList();

    return SimpleDialog(
      title: const TextWidget(
        text: [
          TextSpan(text: 'Try exchange duty time with someone'),
        ],
        compact: true,
      ),
      children: [...list],
    );
  }
}
