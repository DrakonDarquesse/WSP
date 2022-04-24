import 'package:app/models/member.dart';
import 'package:app/network/member.dart';
import 'package:app/network/role.dart';
import 'package:app/network/roster.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/enum.dart';
import 'package:app/widgets/blocked_date_form.dart';
import 'package:app/widgets/roster_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDialogWidget extends ConsumerWidget {
  final String text;

  const AddDialogWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    List<Widget> roleWidgets = [
      TextWidget(
        text: [
          TextSpan(
            text: text,
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
      if (ref.watch(modelProvider) == Model.role)
        RoleFormWidget(callback: (val) {
          ref.watch(roleProvider.notifier).assign(val);
        }),
      if (ref.watch(modelProvider) == Model.roster) const RosterFormWidget(),
      if (ref.watch(modelProvider) == Model.blockedDate)
        const BlockedDateForm(),
      const Divider(),
      ButtonWidget(
        text: text,
        callback: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if (ref.watch(modelProvider) == Model.role) {
              await addRole(ref.watch(roleProvider)).then((value) {
                ref.read(roleListProvider.notifier).load();
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
            if (ref.watch(modelProvider) == Model.roster) {
              await addRoster(ref.read(rosterProvider)).then((value) {
                ref.read(rosterListProvider.notifier).load();
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
            if (ref.watch(modelProvider) == Model.blockedDate) {
              Member newMember = Member(
                  id: ref.read(sessionProvider)!.id,
                  email: ref.read(sessionProvider)!.email,
                  name: ref.read(sessionProvider)!.name,
                  roles: ref.read(sessionProvider)!.roles,
                  blockedDates: [
                    ...ref.read(sessionProvider)!.blockedDates,
                    ref.read(blockedDateProvider)
                  ]);

              await editMember(newMember).then((value) {
                ref.read(sessionProvider.notifier).getMember();
                ref.read(memberListProvider.notifier).load();
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
          }
        },
      ),
    ];
    return Dialog(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: roleWidgets,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 320, vertical: 0),
    );
  }
}
