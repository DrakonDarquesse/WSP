import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/dialog_widget.dart';
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
    return Column(
      children: [
        ButtonWidget(
          text: 'Add',
          callback: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddDialogWidget(
                  text: 'Add Role',
                  model: 'Role',
                );
              },
            );
          },
          icon: Icons.add_circle_outline_rounded,
        ),
        Card(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index != 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditDialogWidget(
                          text: 'Role info',
                          model: dataList[index - 1],
                        );
                      },
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(isMobile(context) ? 16 : 0),
                  child: Flex(
                    children: isMobile(context)
                        ? widgetList(index)
                        : (index == 0 ? header! : widgetList(index - 1)),
                    direction:
                        isMobile(context) ? Axis.vertical : Axis.horizontal,
                    mainAxisSize:
                        isMobile(context) ? MainAxisSize.min : MainAxisSize.max,
                    mainAxisAlignment: isMobile(context)
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    crossAxisAlignment: isMobile(context)
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                  ),
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
          margin: const EdgeInsets.all(16),
          elevation: 2,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
