import 'package:app/models/role.dart';
import 'package:app/network/role.dart';
import 'package:app/provider.dart';
import 'package:app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roleProvider = StateProvider<Role>((ref) {
  return Role(name: '', task: '');
});

final formKeyProvider = StateProvider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});

class AddDialogWidget extends ConsumerWidget {
  final String text;

  const AddDialogWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> roleWidgets = [
      TextWidget(
        text: [
          TextSpan(
            text: text,
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
      ref.watch(modelProvider) == Model.role
          ? RoleFormWidget(
              callback: (val) {
                ref.watch(roleProvider.notifier).state = val;
              },
            )
          : RoleFormWidget(callback: (val) {
              ref.watch(roleProvider.notifier).state = val;
            }),
      const Divider(),
      ButtonWidget(
        text: text,
        callback: () async {
          if (ref.watch(formKeyProvider).currentState!.validate()) {
            ref.watch(formKeyProvider).currentState!.save();
            ref.watch(modelProvider) == Model.role
                ? addRole(ref.watch(roleProvider)).then((value) {
                    ref.read(roleListProvider.notifier).load();
                    Navigator.of(context, rootNavigator: true).pop();
                  })
                : addRole(ref.watch(roleProvider));
          }
        },
      ),
    ];
    return Dialog(
      child: Container(
        child: Form(
          key: ref.watch(formKeyProvider),
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
