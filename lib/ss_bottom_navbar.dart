library ss_bottom_navbar;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ss_bottom_navbar/service.dart';
import 'package:ss_bottom_navbar/views/nav_item.dart';
import 'package:ss_bottom_navbar/views/slide_box.dart';

class SSBottomNav extends StatefulWidget {
  final List<SSBottomNavItem> items;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final Color unselectedColor;
  final ValueChanged<int> onTabSelected;
  final List<BoxShadow> shadow;

//  final int selected;
  final Duration duration;

//  final bool isWidthFixed;

  SSBottomNav(
      {@required this.items,
      this.iconSize,
      this.backgroundColor,
      this.color,
      this.selectedColor,
      this.unselectedColor,
      this.onTabSelected,
      this.shadow,
//      this.selected,
      this.duration
//      this.isWidthFixed = false
      });

  @override
  _SSBottomNavState createState() => _SSBottomNavState();
}

class _SSBottomNavState extends State<SSBottomNav> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Service(),
      child: BottomNavBar(
          items: widget.items,
          iconSize: widget.iconSize,
          backgroundColor: widget.backgroundColor,
          color: widget.color,
          selectedColor: widget.selectedColor,
          unselectedColor: widget.unselectedColor,
          onTabSelected: widget.onTabSelected,
          shadow: widget.shadow,
          selected: null,
          isWidthFixed: false,
          duration: widget.duration),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final List<SSBottomNavItem> items;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final Color unselectedColor;
  final ValueChanged<int> onTabSelected;
  final List<BoxShadow> shadow;
  final int selected;
  final bool isWidthFixed;
  final Duration duration;

  BottomNavBar(
      {@required this.items,
      this.iconSize,
      this.backgroundColor,
      this.color,
      this.selectedColor,
      this.unselectedColor,
      this.onTabSelected,
      this.shadow,
      this.selected,
      this.isWidthFixed,
      this.duration});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var _isInit = false;
  int _index = 0;
  Service _service;
  bool _didUpdateWidget = false;

  @override
  void didUpdateWidget(BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_service.clickedIndex < _service.items.length) _service.selected = _service.clickedIndex;
    if (_service.clickedIndex != _service.selected) _didUpdateWidget = true;
  }

  _updateIndex(int index, {bool didUpdateWidget = false}) async {
    if (widget.onTabSelected != null && _index != index) widget.onTabSelected.call(index);

    _index = index;
    _service.settings.selected = _index;
    _service.setSelected(index, didUpdateWidget: didUpdateWidget);
  }

  @override
  Widget build(BuildContext context) {
    _service = Provider.of<Service>(context, listen: false);

    if (_service.items.isEmpty) {
      _service.init(widget.items,
          settings: SSBottomNavBarSettings(
              items: widget.items,
              iconSize: widget.iconSize,
              backgroundColor: widget.backgroundColor,
              color: widget.color,
              selectedColor: widget.selectedColor,
              unselectedColor: widget.unselectedColor,
              onTabSelected: widget.onTabSelected,
              shadow: widget.shadow,
              isWidthFixed: widget.isWidthFixed,
              duration: widget.duration));

      if (!_isInit)
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 200));

          _service.setSelected(0);
          _isInit = true;
        });
    }

    if (_didUpdateWidget) {
      _updateIndex(widget.selected, didUpdateWidget: true);
      _didUpdateWidget = false;
    }

    return Container(
      color: _service.settings.backgroundColor,
      child: SafeArea(
        child: Container(
          height: kBottomNavigationBarHeight,
          child: Stack(
            children: [
              Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _service.items.map((e) => _EmptyItem(e)).toList()),
              ),
              Container(
                color: widget.backgroundColor ?? Colors.white,
              ),
              if (_service.isBottomSlideVisible) SlideBox(),
              Container(
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _service.items
                        .map((e) => NavItem(
                              e,
                              onTab: () {
                                var index = _service.items.indexOf(e);
                                _service.clickedIndex = index;
                                if (_service.settings.selected == null) _service.setSelected(index);
                                _updateIndex(index);
                              },
                            ))
                        .toList()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SSBottomNavItem {
  final String text;
  final TextStyle textStyle;
  final IconData iconData;
  final double iconSize;
  final bool isIconOnly;

  SSBottomNavItem({@required this.text, this.textStyle, @required this.iconData, this.iconSize = 16, this.isIconOnly = false});
}

class _EmptyItem extends StatefulWidget {
  final SSBottomNavItem ssBottomNavItem;
  final int selected;

  _EmptyItem(this.ssBottomNavItem, {this.selected});

  @override
  _EmptyItemState createState() => _EmptyItemState();
}

class _EmptyItemState extends State<_EmptyItem> {
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
              style: widget.ssBottomNavItem.textStyle ?? TextStyle(),
            ),
          ]
        ],
      ),
    );
  }
}
