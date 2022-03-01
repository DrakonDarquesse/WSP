import 'package:app/screens/accepted_duty.dart';
import 'package:app/utils/colours.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/screens/all.dart';

class MemberSchedule extends StatefulWidget {
  final String title;

  const MemberSchedule({Key? key, required this.title}) : super(key: key);

  @override
  State<MemberSchedule> createState() => _MemberScheduleState();
}

class _MemberScheduleState extends State<MemberSchedule>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> tabs = const [
    Tab(text: 'Blocked Dates'),
    Tab(text: 'Pending'),
    Tab(text: 'Accepted'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: isMobile(context)
            ? TabBar(
                tabs: tabs,
                controller: _tabController,
              )
            : null,
        backgroundColor: blue(),
      ),
      body: isMobile(context)
          ? TabBarView(
              controller: _tabController,
              children: const [
                BlockedDates(),
                PendingRequest(),
                AcceptedDuty(),
              ],
            )
          : Row(
              children: [
                const NavBar(),
                const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  child: Column(
                    children: const [
                      TextWidget(
                        text: [
                          TextSpan(text: 'Blocked Dates'),
                        ],
                        alignment: TextAlign.center,
                      ),
                      Expanded(child: BlockedDates()),
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Column(
                    children: const [
                      TextWidget(
                        text: [
                          TextSpan(text: 'Pending Request'),
                        ],
                        alignment: TextAlign.center,
                      ),
                      Expanded(child: PendingRequest()),
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Column(
                    children: const [
                      TextWidget(
                        text: [
                          TextSpan(text: 'Accepted'),
                        ],
                        alignment: TextAlign.center,
                      ),
                      Expanded(child: AcceptedDuty()),
                    ],
                  ),
                  flex: 1,
                ),
                const Padding(padding: EdgeInsets.all(10)),
              ],
              mainAxisSize: MainAxisSize.max,
            ),
      bottomNavigationBar: isMobile(context) ? const NavBar() : null,
    );
  }
}
