import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ss_bottom_navbar/service.dart';
import 'package:ss_bottom_navbar/ss_bottom_navbar.dart';

class EmptyItem extends StatefulWidget {
  final SSBottomNavItem ssBottomNavItem;
  final int selected;

  EmptyItem(this.ssBottomNavItem, {this.selected});

  @override
  EmptyItemState createState() => EmptyItemState();
}

class EmptyItemState extends State<EmptyItem> {
  bool _isInit = false;
  var _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<Service>(context);

    var index = service.items.indexOf(widget.ssBottomNavItem);
    var selected = service.emptySelectedIndex == index;

    _postFrameCallback() async {
      _isInit = true;

      if (!selected) return;

      try {
        await Future.delayed(Duration(milliseconds: 200 + index * 12));

        RenderBox box = _key.currentContext.findRenderObject();
        Offset position = box.localToGlobal(Offset.zero);

        service.positionsBig[service.emptySelectedIndex] = position;
        service.sizesBig[service.emptySelectedIndex] = Offset(_key.currentContext.size.width, _key.currentContext.size.height);

        service.setEmptySelectedIndex(index + 1);
      } catch (e) {}
    }

    if (service.sizesBig[index] == Offset.zero &&
        service.positionsBig[index] == Offset.zero &&
        service.emptySelectedIndex <= service.items.length - 1) {
      if (!_isInit) WidgetsBinding.instance.addPostFrameCallback((_) => _postFrameCallback());
      if (selected) _postFrameCallback();
    }

    return Container(
      margin: EdgeInsets.all(8),
      key: _key,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.ssBottomNavItem.iconData,
            size: widget.ssBottomNavItem.iconSize ?? 16,
          ),
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