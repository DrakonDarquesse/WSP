import 'package:app/models/member.dart';
import 'package:app/models/role.dart';

class DutyRoster {
  DateTime _date;
  String _title;
  Member _member;
  Role _role;

  DutyRoster({
    date,
    title,
    member,
    role,
  })  : _date = date,
        _title = title,
        _member = member,
        _role = role;

  get date => _date;
  get title => _title;
  get member => _member;
  get role => _role;

  set date(value) => _date = value;
  set title(value) => _title = value;
  set member(value) => _member = value;
  set role(value) => _role = value;
}
