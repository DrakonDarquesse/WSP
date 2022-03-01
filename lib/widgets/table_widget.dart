import 'package:app/utils/adaptive.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List dataList;
  final VoidCallback? callback;
  final List<Widget> Function(int) widgetList;
  final List<Widget>? header;

  const TableWidget({
    Key? key,
    required this.dataList,
    required this.widgetList,
    this.header,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(isMobile(context) ? 16 : 0),
            child: Flex(
              children: isMobile(context)
                  ? widgetList(index)
                  : (index == 0 ? header! : widgetList(index - 1)),
              direction: isMobile(context) ? Axis.vertical : Axis.horizontal,
              mainAxisSize:
                  isMobile(context) ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: isMobile(context)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment: isMobile(context)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1, indent: 10, endIndent: 10),
        shrinkWrap: true,
        itemCount: isMobile(context)
            ? dataList.length
            : dataList.isEmpty
                ? 1
                : dataList.length + 1,
      ),
      margin: const EdgeInsets.all(20),
      elevation: 2,
    );
  }
}
