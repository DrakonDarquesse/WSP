import 'package:app/provider.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/utils/enum.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> widgets = [
      Card(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ref.watch(modeProvider.notifier).state = Mode.edit;
                if (index != 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditDialogWidget(
                        text: 'Edit',
                        model: dataList[index - 1],
                      );
                    },
                  );
                }
              },
              child: MouseRegion(
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
                cursor: SystemMouseCursors.click,
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
    ];

    if (ref.watch(modelProvider) == Model.role) {
      widgets.insert(
          0,
          ButtonWidget(
            text: 'Add',
            callback: () {
              ref.watch(modeProvider.notifier).state = Mode.add;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AddDialogWidget(
                    text: 'Add Role',
                  );
                },
              );
            },
            icon: Icons.add_circle_outline_rounded,
          ));
    }
    return Column(
      children: widgets,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
