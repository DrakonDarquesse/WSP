import 'package:app/models/blocked_date.dart';
import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/validate.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BlockedDateForm extends ConsumerStatefulWidget {
  const BlockedDateForm({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BlockedDateForm> createState() => _BlockedDateFormState();
}

class _BlockedDateFormState extends ConsumerState<BlockedDateForm> {
  DateTime selectedDate = DateTime.now();

  void _changeNote(String value) {
    BlockedDate bd = BlockedDate(
      date: ref.read(blockedDateProvider).date,
      note: value,
    );
    ref.read(blockedDateProvider.notifier).state = bd;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        selectableDayPredicate: (DateTime d) {
          if (d.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
            return true;
          }
          return false;
        });
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      BlockedDate bd = BlockedDate(
        date: picked,
        note: ref.read(blockedDateProvider).note,
      );
      ref.read(blockedDateProvider.notifier).state = bd;
    }
  }

  @override
  Widget build(BuildContext context) {
    final BlockedDate bd = ref.watch(blockedDateProvider);

    return Column(
      children: [
        Row(
          children: [
            TextWidget(text: [
              TextSpan(
                text: 'Date: ${DateFormat('yMd').format(selectedDate)}',
                style: Theme.of(context).textTheme.headline6,
              )
            ]),
            ButtonWidget(
                text: 'Pick Date',
                callback: () async {
                  await _selectDate(context);
                }),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        FormWidget(
          info: 'Note',
          helper: 'Simple the best',
          save: (String? value) {
            _changeNote(value!);
          },
          validator: (String? value) {
            return Validator.checkEmpty(value);
          },
          initialValue: bd.note,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
