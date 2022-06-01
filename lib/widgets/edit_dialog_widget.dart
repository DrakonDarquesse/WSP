import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_member.dart';
import 'package:app/network/member.dart';
import 'package:app/network/role.dart';
import 'package:app/network/roster.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/widgets/role_member_form.dart';
import 'package:app/widgets/roster_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colours.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditDialogWidget extends ConsumerStatefulWidget {
  final dynamic model;
  final String text;

  const EditDialogWidget({
    Key? key,
    required this.text,
    this.model,
  }) : super(key: key);

  @override
  ConsumerState<EditDialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends ConsumerState<EditDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  late Role _role;
  late Member _member;

  bool _editability = false;

  void _changeModel(dynamic model) => setState(() {
        if (widget.model is Role) {
          _role = model;
        }
        if (widget.model is Member) {
          _member = model;
        }
      });

  void _changeStatus(bool s) => setState(() {
        if (widget.model is Role) {
          _role.isEnabled = s;
        }
        if (widget.model is Member) {
          _member.isActive = s;
        }
      });

  void _editabilityChanged() {
    setState(() {
      _editability = !_editability;
    });
  }

  @override
  void initState() {
    if (widget.model is Role) {
      _role = widget.model as Role;
    }
    if (widget.model is Member) {
      _member = widget.model as Member;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Row(
        children: [
          Expanded(
            child: TextWidget(
              text: [
                TextSpan(
                  text: widget.text,
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
          ),
          if (widget.model is! DutyRoster) ...[
            AbsorbPointer(
              child: Switch(
                value:
                    widget.model is Role ? _role.isEnabled : _member.isActive,
                onChanged: _changeStatus,
              ),
              absorbing: ref.watch(sessionProvider.notifier).role != 'admin',
            ),
            TextWidget(
              text: [
                TextSpan(
                  text: widget.model is Role
                      ? _role.getIsEnabled()
                      : _member.getIsActive(),
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ]
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      if (widget.model is Role)
        RoleFormWidget(
          callback: (val) => _changeModel(val),
          role: _role,
        ),
      if (widget.model is Member)
        MemberFormWidget(
          callback: (val) => _changeModel(val),
          member: _member,
        ),
      if (widget.model is DutyRoster) const RosterFormWidget(),
      if (widget.model is RoleMember) const RoleMemberForm(),
      if (ref.watch(sessionProvider.notifier).role == 'admin') ...[
        const Divider(),
        ButtonWidget(
          text: 'Save Change',
          callback: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              if (widget.model is Role) {
                await editRole(_role).then((value) {
                  ref.read(roleListProvider.notifier).load();
                  Navigator.of(context, rootNavigator: true).pop();
                });
              }
              if (widget.model is Member) {
                await editMember(_member).then((value) {
                  ref.read(memberListProvider.notifier).load();
                  ref.read(roleListProvider.notifier).load();
                  ref.read(sessionProvider.notifier).getMember();
                  Navigator.of(context, rootNavigator: true).pop();
                });
              }
              if (widget.model is DutyRoster) {
                await editRoster(ref.read(rosterProvider)).then((value) {
                  ref.read(rosterListProvider.notifier).load();
                  Navigator.of(context, rootNavigator: true).pop();
                });
              }
            }
          },
        ),
        if (widget.model is! Member)
          ButtonWidget(
            text: 'Delete',
            callback: () async {
              if (widget.model is Role) {
                await deleteRole(_role).then((value) {
                  Navigator.of(context, rootNavigator: true).pop();
                  ref.read(roleListProvider.notifier).load();
                });
              }
              if (widget.model is Member) {
                await deleteMember(_member).then((value) {
                  Navigator.of(context, rootNavigator: true).pop();
                  ref.read(memberListProvider.notifier).load();
                });
              }
              if (widget.model is DutyRoster) {
                await deleteRoster(ref.read(rosterProvider)).then((value) {
                  ref.read(rosterListProvider.notifier).load();
                  Navigator.of(context, rootNavigator: true).pop();
                });
              }
            },
            color: red(),
          )
      ],
      if (ref.watch(sessionProvider.notifier).role == 'member' &&
          widget.model is Member &&
          ref.watch(sessionProvider) == widget.model) ...[
        const Divider(),
        ButtonWidget(
          text: 'Save Change',
          callback: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              if (widget.model is Role) {
                await editRole(_role).then((value) {
                  ref.read(roleListProvider.notifier).load();
                  Navigator.of(context, rootNavigator: true).pop();
                });
              }
              if (widget.model is Member) {
                await editMember(_member).then((value) {
                  ref.read(memberListProvider.notifier).load();
                  ref.read(roleListProvider.notifier).load();
                  ref.read(sessionProvider.notifier).getMember();
                  Navigator.of(context, rootNavigator: true).pop();
                });
              }
              if (widget.model is DutyRoster) {
                await editRoster(ref.read(rosterProvider)).then((value) {
                  ref.read(rosterListProvider.notifier).load();
                  Navigator.of(context, rootNavigator: true).pop();
                });
              }
            }
          },
        ),
      ]
    ];
    return Dialog(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: widgets,
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
