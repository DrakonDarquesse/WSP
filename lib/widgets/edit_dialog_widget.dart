import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/network/member.dart';
import 'package:app/network/role.dart';
import 'package:app/provider.dart';
import 'package:app/utils/size.dart';
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
          Switch(
            value: widget.model is Role ? _role.isEnabled : _member.isActive,
            onChanged: _changeStatus,
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
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      widget.model is Role
          ? RoleFormWidget(
              callback: (val) => _changeModel(val),
              role: _role,
            )
          : MemberFormWidget(
              callback: (val) => _changeModel(val),
              member: _member,
            ),
      const Divider(),
      ButtonWidget(
        text: 'Save Change',
        callback: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await widget.model is Role
                ? editRole(_role).then((value) {
                    ref.read(roleListProvider.notifier).load();
                    Navigator.of(context, rootNavigator: true).pop();
                  })
                : editMember(_member).then((value) {
                    ref.read(memberListProvider.notifier).load();
                    Navigator.of(context, rootNavigator: true).pop();
                  });
          }
        },
      ),
      ButtonWidget(
        text: 'Delete',
        callback: () async {
          await widget.model is Role
              ? deleteRole(_role).then((value) {
                  Navigator.of(context, rootNavigator: true).pop();
                  ref.read(roleListProvider.notifier).load();
                })
              : deleteMember(_member).then((value) {
                  Navigator.of(context, rootNavigator: true).pop();
                  ref.read(memberListProvider.notifier).load();
                });
        },
        color: red(),
      )
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
