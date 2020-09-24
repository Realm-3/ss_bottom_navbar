import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ss_bottom_navbar/ss_bottom_navbar.dart';

import '../service.dart';

class NavItem extends StatefulWidget {
  final SSBottomNavItem ssBottomNavItem;
  final bool isActive;
  final Function onTab;

  NavItem(this.ssBottomNavItem, {this.isActive, this.onTab});

  @override
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> with TickerProviderStateMixin {
  bool _isActive = false;
  bool _isInit = false;

  @override
  void initState() {
    if (widget.isActive != null) _isActive = widget.isActive;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<Service>(context);
    var _index = service.items.indexOf(widget.ssBottomNavItem);
    var _selected = _index == service.selected;
    var _key = service.keys[_index];
    var size = MediaQuery.of(context).size;

    var _textStyle = widget.ssBottomNavItem.textStyle ?? TextStyle(fontSize: 14);

    _isActive = service.selected == _index;

    _postFrameCallback() {
      RenderBox renderBoxRed = _key.currentContext.findRenderObject();
      var positionRed = renderBoxRed.localToGlobal(Offset.zero);

      setState(() {
        _isInit = true;
      });

      service.setSizeAndPosition(
          index: _index,
          size: Offset(_key.currentContext.size.width, _key.currentContext.size.height),
          position: positionRed);
    }

    if (!_isInit) WidgetsBinding.instance.addPostFrameCallback((_) => _postFrameCallback());

    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: widget.onTab,
        child: AnimatedPadding(
          padding: EdgeInsets.only(left: service.items[service.selected].isIconOnly ? 0 : _selected ? service.settings.isWidthFixed
              ? (service.sizesBig.reduce((curr, next) => curr.dx > next.dx ? curr : next).dx - service.sizesBig[service.selected].dx) : 0 : 0),
          duration: service.animationDuration,
          curve: Curves.easeOutExpo,
          child: Container(
            margin: EdgeInsets.all(size.height*0.01),
            key: _key,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.ssBottomNavItem.iconData,
                  color: _isActive ? service.settings.selectedColor : service.settings.unselectedColor,
 size: widget.ssBottomNavItem.iconSize ?? service.settings.iconSize ?? 4,                ),
                AnimatedSize(
                  curve: Curves.easeOutExpo,
                  vsync: this,
                  duration: service.animationDuration,
                  child: Container(
                    width: widget.ssBottomNavItem.isIconOnly ? 0 : service.state == SSBottomNavBarState.icon ? 0 : _isActive ? null : 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: size.width*0.02,
                        ),
                        Text(
                          widget.ssBottomNavItem.text,
                          style: _textStyle.apply(color: _isActive ? service.settings.selectedColor : service.settings.unselectedColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
