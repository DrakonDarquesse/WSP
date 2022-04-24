import 'package:app/models/role.dart';
import 'package:app/models/role_deck.dart';
import 'package:app/network/role_deck.dart';
import 'package:app/provider.dart';
import 'package:app/provider/role_deck_provider.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/validate.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colours.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleDeckForm extends ConsumerWidget {
  final RoleDeck? roledeck;
  const RoleDeckForm({Key? key, required this.roledeck}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _formKey = GlobalKey<FormState>();

    final _roles = ref.watch(roleListProvider);

    void _changeRoles(Role role, bool select) {
      if (select) {
        ref.watch(selectedRolesProvider.notifier).state = {
          ...ref.watch(selectedRolesProvider),
          role
        };
      } else {
        ref.watch(selectedRolesProvider.notifier).state = {
          ...ref.watch(selectedRolesProvider).where((r) => r != role)
        };
      }
    }

    void reset() {
      ref.watch(selectedRolesProvider.notifier).state = {};
      ref.watch(titleProvider.notifier).state = '';
    }

    return Dialog(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextWidget(
                text: [
                  TextSpan(
                    text: 'Add Role and Member',
                    style: Theme.of(context).textTheme.headline5,
                  )
                ],
              ),
              FormWidget(
                info: 'Title',
                helper: 'Simple the best',
                validator: (String? value) {
                  final _roles = ref.watch(roleListProvider);
                  if (ref.watch(modeProvider) == Mode.add) {
                    return checkEmpty(value) ?? checkDuplicate(_roles, value!);
                  } else {
                    return checkEmpty(value);
                  }
                },
                initialValue: ref.read(titleProvider),
                callback: (val) {
                  ref.read(titleProvider.notifier).state = val;
                },
                readOnly: ref.watch(sessionProvider.notifier).role != 'admin',
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
                              selected: ref
                                  .watch(selectedRolesProvider)
                                  .where((r) => r == role)
                                  .isNotEmpty);
                        }).toList(),
                        runSpacing: 8,
                        spacing: 10,
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              const Divider(),
              if (ref.watch(modeProvider) == Mode.add)
                ButtonWidget(
                  text: 'Add',
                  callback: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      RoleDeck rd = RoleDeck(
                          title: ref.watch(titleProvider),
                          roles: ref.watch(selectedRolesProvider));
                      await addRoleDeck(rd).then((value) {
                        ref.read(roleDeckListProvider.notifier).load();
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                      reset();
                    }
                  },
                ),
              if (ref.watch(modeProvider) == Mode.edit) ...[
                ButtonWidget(
                    text: 'Save Change',
                    callback: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        RoleDeck rd = RoleDeck(
                            id: roledeck!.id,
                            title: ref.watch(titleProvider),
                            roles: ref.watch(selectedRolesProvider));
                        await editRoleDeck(rd).then((value) {
                          ref.read(roleDeckListProvider.notifier).load();
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                        reset();
                      }
                    }),
                ButtonWidget(
                  text: 'Delete',
                  callback: () async {
                    await deleteRoleDeck(roledeck!).then((value) {
                      ref.read(roleDeckListProvider.notifier).load();
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                    reset();
                  },
                  color: red(),
                )
              ]
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 320, vertical: 0),
    );
  }
}
