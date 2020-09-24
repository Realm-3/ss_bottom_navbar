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

  Service service;
  int index;
  var selected = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (service.sizesBig[index] == Offset.zero &&
      //     service.positionsBig[index] == Offset.zero &&
      //     service.emptySelectedIndex <= service.items.length - 1) {
      //
      //   if (service.positionsBig[service.emptySelectedIndex] != Offset.zero && service.positionsBig[service.emptySelectedIndex] != Offset.zero) {
      //     service.setEmptySelectedIndex(index + 1);
      //     return;
      //   }
      //   await Future.delayed(Duration(milliseconds: 200 + index * 12));

        RenderBox box1 = _key.currentContext.findRenderObject();
        Offset position1 = box1.localToGlobal(Offset.zero);

        service.positionsBig[index] = position1;


        service.sizesBig[index] = Offset(_key.currentContext.size.width, _key.currentContext.size.height);



        print(index);
        print(_key.currentContext.size);

        index = service.setEmptySelectedIndex(index + 1);

        RenderBox box = _key.currentContext.findRenderObject();
        Offset position = box.localToGlobal(Offset.zero);

        service.positionsBig[index] = position;


        service.sizesBig[index] = Offset(_key.currentContext.size.width, _key.currentContext.size.height);



        print(index);
        print(_key.currentContext.size);

        // print(service.emptySelectedIndex);
        // print(service.sizesBig[service.emptySelectedIndex]);
        // print(service.positionsBig[service.emptySelectedIndex]);
        // print(service.positionsBig[service.emptySelectedIndex] == Offset.zero);
        // print(service.positionsBig[service.emptySelectedIndex]== Offset.zero);


    });
  }

  @override
  Widget build(BuildContext context) {
    service = Provider.of<Service>(context);

    index = service.items.indexOf(widget.ssBottomNavItem);
    var selected = service.emptySelectedIndex == index;

    // print(selected);

    _postFrameCallback() async {
      _isInit = true;

      if (!selected) return;

      cal() async {
        if (service.positionsBig[service.emptySelectedIndex] != Offset.zero && service.positionsBig[service.emptySelectedIndex] != Offset.zero) {
          service.setEmptySelectedIndex(index + 1);
          return;
        }
        await Future.delayed(Duration(milliseconds: 200 + index * 12));

        RenderBox box = _key.currentContext.findRenderObject();
        Offset position = box.localToGlobal(Offset.zero);

        service.positionsBig[service.emptySelectedIndex] = position;
        service.sizesBig[service.emptySelectedIndex] = Offset(_key.currentContext.size.width, _key.currentContext.size.height);

        // print(service.emptySelectedIndex);
        // print(service.sizesBig[service.emptySelectedIndex]);
        // print(service.positionsBig[service.emptySelectedIndex]);
        // print(service.positionsBig[service.emptySelectedIndex] == Offset.zero);
        // print(service.positionsBig[service.emptySelectedIndex]== Offset.zero);

        service.setEmptySelectedIndex(index + 1);
      }

      try {
       // while(service.sizesBig[service.emptySelectedIndex] == Offset.zero || service.positionsBig[service.emptySelectedIndex] == Offset.zero) {
       // }
       cal();
      } catch (e) {
        print(e);
      }
    }

    return Container(
      margin: EdgeInsets.all(8),
      key: _key,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.ssBottomNavItem.iconData,
            size: widget.ssBottomNavItem.iconSize ?? service.settings.iconSize ?? 16,
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