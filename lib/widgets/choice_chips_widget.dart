import 'package:app/models/role.dart';
import 'package:app/utils/colours.dart';
import 'package:flutter/material.dart';

class ChoiceChipsWidget extends StatelessWidget {
  final List<dynamic> choice;
  final void Function(bool, dynamic) onSelect;
  final bool Function(dynamic) isSelect;
  final Color Function(dynamic) color;
  const ChoiceChipsWidget({
    Key? key,
    required this.choice,
    required this.onSelect,
    required this.isSelect,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        children: choice.map<ChoiceChip>((choice) {
          return ChoiceChip(
            avatar: CircleAvatar(
              backgroundColor: choice is Role ? choice.color : blue(),
              child: Text(
                choice.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            label: Text(choice.name),
            backgroundColor: color(choice),
            onSelected: (bool select) {
              return onSelect(select, choice);
            },
            selectedColor: warning().withOpacity(0.5),
            selected: isSelect(choice),
          );
        }).toList(),
        runSpacing: 8,
        spacing: 10,
      ),
    );
  }
}
