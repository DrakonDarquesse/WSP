import 'package:app/models/duty_roster.dart';
import 'package:app/models/role.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';

Map<DutyRoster, List<int>> generateCategory(
    List<DutyRoster> rosters, List<Role> roles) {
  Map<DutyRoster, List<int>> categories = {};

  for (var i = 0; i < rosters.length; i++) {
    if (categories.keys.toList().contains(rosters[i])) {
      print('equal');
      DutyRoster key = categories.keys.firstWhere((k) => k == rosters[i]);
      categories[key] = [...categories[key]!, i];
    } else {
      categories.putIfAbsent(rosters[i], () => [i]);
    }
  }

  return categories;
}

List<Widget> header(Set<Role> r, bool isAdmin) {
  return [
    const Expanded(
      child: TextWidget(
        text: [
          TextSpan(
            text: 'Date',
          ),
        ],
        compact: false,
      ),
    ),
    const Expanded(
      child: TextWidget(
        text: [
          TextSpan(
            text: 'Title',
          ),
        ],
        compact: false,
      ),
    ),
    ...r.where((role) => role.isEnabled).map((role) {
      return Expanded(
        child: TextWidget(
          text: [
            TextSpan(
              text: role.name,
            ),
          ],
          compact: false,
        ),
      );
    }).toList(),
    if (isAdmin)
      const TextWidget(
        text: [
          TextSpan(
            text: 'Action',
          ),
        ],
        compact: false,
      ),
  ];
}
