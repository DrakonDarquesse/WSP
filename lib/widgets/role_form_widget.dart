import 'package:app/models/role.dart';
import 'package:app/provider.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/validate.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleFormWidget extends ConsumerStatefulWidget {
  final void Function(Role)? callback;
  final Role? role;
  const RoleFormWidget({Key? key, this.callback, this.role}) : super(key: key);

  @override
  ConsumerState<RoleFormWidget> createState() => _RoleFormWidgetState();
}

class _RoleFormWidgetState extends ConsumerState<RoleFormWidget> {
  late final Role _role;

  List<Color> currentColors = [
    Colors.yellow.shade600,
    Colors.lime.shade600,
    Colors.green.shade600,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
  ];

  void _changeColor(Color color) => setState(() {
        _role.color = color;
      });

  void _changeRoleName(String name) => setState(() {
        _role.name = name;
        if (widget.callback != null) {
          widget.callback!(_role);
        }
      });

  void _changeRoleTask(String task) => setState(() {
        _role.task = task;
      });

  @override
  void initState() {
    _role = widget.role ?? Role(name: '', task: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormWidget(
          info: 'Name',
          helper: 'Simple the best',
          validator: (String? value) {
            final _roles = ref.watch(roleListProvider);
            if (ref.watch(modeProvider) == Mode.add) {
              return checkEmpty(value) ?? checkDuplicate(_roles, value!);
            } else {
              return checkEmpty(value);
            }
          },
          save: (String? value) {
            _changeRoleName(value!);
          },
          initialValue: _role.name,
          readOnly: ref.watch(sessionProvider.notifier).role != 'admin',
        ),
        Container(
          child: TextFormField(
            textAlignVertical: TextAlignVertical.top,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(
                hintText: 'Enter Tasks',
                border: OutlineInputBorder(),
                label: Text('Tasks'),
                helperText: 'The what, when and how',
                alignLabelWithHint: true),
            onSaved: (String? value) {
              _changeRoleTask(value!);
            },
            initialValue: _role.task,
            readOnly: ref.watch(sessionProvider.notifier).role != 'admin',
          ),
          constraints: const BoxConstraints(maxHeight: 150),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        ),
        if (ref.watch(sessionProvider.notifier).role == 'admin') ...[
          TextWidget(text: [
            TextSpan(
              text: 'Colour',
              style: Theme.of(context).textTheme.subtitle1,
            )
          ]),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlockPicker(
                pickerColor: _role.color,
                onColorChanged: _changeColor,
                availableColors: currentColors,
              ),
            ),
          ),
        ]
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
