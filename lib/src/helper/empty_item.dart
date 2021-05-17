import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ss_bottom_navbar/src/service.dart';
import 'package:ss_bottom_navbar/src/ss_bottom_navbar.dart';

class EmptyItem extends StatefulWidget {
  final SSBottomNavItem ssBottomNavItem;
  final int? selected;

  const EmptyItem(this.ssBottomNavItem, {this.selected});

  @override
  EmptyItemState createState() => EmptyItemState();
}

class EmptyItemState extends State<EmptyItem> {
  bool _isInit = false;
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<SSBottomBarState>(context);

    final index = service.items.indexOf(widget.ssBottomNavItem);
    final selected = service.emptySelectedIndex == index;

    Future<void> _postFrameCallback() async {
      _isInit = true;

      if (!selected) return;

      try {
        await Future<void>.delayed(Duration(milliseconds: 200 + index * 12));

        final box = _key.currentContext!.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);

        service.positionsBig[service.emptySelectedIndex] = position;
        service.sizesBig[service.emptySelectedIndex] = Offset(_key.currentContext!.size!.width, _key.currentContext!.size!.height);

        service.setEmptySelectedIndex(index + 1);
      } catch (e) {
        debugPrintStack(label: e.toString());
      }
    }

    if (service.sizesBig[index] == Offset.zero &&
        service.positionsBig[index] == Offset.zero &&
        service.emptySelectedIndex <= service.items.length - 1) {
      if (!_isInit) WidgetsBinding.instance!.addPostFrameCallback((_) => _postFrameCallback());
      if (selected) _postFrameCallback();
    }

    return Container(
      margin: EdgeInsets.all(8),
      key: _key,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.ssBottomNavItem.iconData, size: service.settings?.iconSize ?? widget.ssBottomNavItem.iconSize),
          if (selected && !widget.ssBottomNavItem.isIconOnly) ...[
            SizedBox(
              width: 5,
            ),
            Text(
              widget.ssBottomNavItem.text,
              style: widget.ssBottomNavItem.textStyle ?? TextStyle(fontSize: 14),
            ),
          ]
        ],
      ),
    );
  }
}
