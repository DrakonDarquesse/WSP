import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/provider.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colours.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberFormWidget extends ConsumerStatefulWidget {
  final void Function(Member)? callback;
  final Member member;
  const MemberFormWidget({Key? key, this.callback, required this.member})
      : super(key: key);

  @override
  ConsumerState<MemberFormWidget> createState() => _MemberFormWidgetState();
}

class _MemberFormWidgetState extends ConsumerState<MemberFormWidget> {
  late final Member _member;

  void _changeRoles(Role role, bool select) {
    setState(() {
      if (select) {
        _member.roles.add(role);
      } else {
        _member.roles.removeWhere((r) => r == role);
      }

      if (widget.callback != null) {
        widget.callback!(_member);
      }
    });
  }

  @override
  void initState() {
    _member = widget.member;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _roles = ref.watch(roleListProvider);
    return Column(
      children: [
        TextWidget(
          text: [
            TextSpan(
              text: _member.name,
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
        TextWidget(
          text: [
            TextSpan(
              text: _member.email,
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
        TextWidget(text: [
          TextSpan(
            text: 'Role',
            style: Theme.of(context).textTheme.subtitle1,
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _roles.isNotEmpty
              ? Wrap(
                  children: _roles.map<FilterChip>((role) {
                    return FilterChip(
                      avatar: CircleAvatar(
                        backgroundColor: role.color,
                        child: Text(
                          role.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      label: Text(role.name),
                      backgroundColor: role.color.withOpacity(0.15),
                      onSelected: (bool select) {
                        _changeRoles(role, select);
                      },
                      selectedColor: yellow(),
                      selected: widget.member.roles
                          .where((r) => r == role)
                          .toList()
                          .isNotEmpty,
                    );
                  }).toList(),
                  runSpacing: 8,
                  spacing: 10,
                )
              : const Center(child: CircularProgressIndicator()),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 60),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
