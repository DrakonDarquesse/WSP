import 'package:app/provider.dart';
import 'package:app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UseRoleSetForm extends ConsumerWidget {
  const UseRoleSetForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleDecks = ref.watch(roleDeckListProvider);

    List<SimpleDialogOption> options =
        roleDecks.map<SimpleDialogOption>((roledeck) {
      return SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, roledeck);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: [
                TextSpan(
                    text: roledeck.title,
                    style: Theme.of(context).textTheme.headline6),
              ],
              compact: true,
            ),
            Text(roledeck.getRoles()),
          ],
        ),
      );
    }).toList();

    return SimpleDialog(
      title: const TextWidget(
        text: [
          TextSpan(text: 'Select Role Set'),
        ],
        compact: true,
      ),
      children: [...options],
    );
  }
}
