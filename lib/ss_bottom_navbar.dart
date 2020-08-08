library ss_bottom_navbar;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ss_bottom_navbar/helper/empty_item.dart';
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
  final bool visible;
  final Widget bottomSheetWidget;
  final int showBottomSheetAt;
  final bool bottomSheetHistory;

//  final int selected;
  final Duration duration;

//  final bool isWidthFixed;

  SSBottomNav({
    @required this.items,
    this.iconSize,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.unselectedColor,
    this.onTabSelected,
    this.shadow,
    this.bottomSheetWidget,
    this.showBottomSheetAt = 0,
//      this.selected,
    this.duration,
    this.visible = true,
    this.bottomSheetHistory = true,
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
        child: _App(
            items: widget.items,
            iconSize: widget.iconSize,
            backgroundColor: widget.backgroundColor,
            color: widget.color,
            selectedColor: widget.selectedColor,
            unselectedColor: widget.unselectedColor,
            onTabSelected: widget.onTabSelected,
            shadow: widget.shadow,
            bottomSheetWidget: widget.bottomSheetWidget,
            showBottomSheetAt: widget.showBottomSheetAt,
            visible: widget.visible,
            bottomSheetHistory: widget.bottomSheetHistory,
            duration: widget.duration));
  }
}

class _App extends StatelessWidget {
  final List<SSBottomNavItem> items;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final Color unselectedColor;
  final ValueChanged<int> onTabSelected;
  final List<BoxShadow> shadow;
  final bool visible;
  final Widget bottomSheetWidget;
  final int showBottomSheetAt;
  final Duration duration;
  final bool bottomSheetHistory;

  _App({
    @required this.items,
    this.iconSize,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.unselectedColor,
    this.onTabSelected,
    this.shadow,
    this.bottomSheetWidget,
    this.showBottomSheetAt,
    this.duration,
    this.visible,
    this.bottomSheetHistory,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).padding;

    return Container(
        height: visible ? kBottomNavigationBarHeight + size.bottom : 0,
        child: BottomNavBar(
            items: items,
            iconSize: iconSize,
            backgroundColor: backgroundColor,
            color: color,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTabSelected: onTabSelected,
            shadow: shadow,
            selected: null,
            isWidthFixed: false,
            bottomSheetWidget: bottomSheetWidget,
            showBottomSheetAt: showBottomSheetAt,
            visible: visible,
            bottomSheetHistory: bottomSheetHistory,
            duration: duration));
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
  final bool visible;
  final Widget bottomSheetWidget;
  final int showBottomSheetAt;
  final bool bottomSheetHistory;

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
      this.visible,
      this.bottomSheetWidget,
      this.showBottomSheetAt,
      this.bottomSheetHistory,
      this.duration});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var _isInit = false;
  int _index = 0;
  int _tempIndex = 0;
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

  _onPressed(Offset offset) async {
    for (var pos in _service.positions) {
      var index = _service.positions.indexOf(pos);
      var rect1 = {'x': pos.dx, 'y': pos.dy, 'width': _service.sizes[index].dx, 'height': _service.sizes[index].dy};
      var rect2 = {'x': offset.dx, 'y': offset.dy, 'width': 1, 'height': 1};

      if (rect1['x'] < rect2['x'] + rect2['width'] &&
          rect1['x'] + rect1['width'] > rect2['x'] &&
          rect1['y'] < rect2['y'] + rect2['height'] &&
          rect1['y'] + rect1['height'] > rect2['y']) {
        Navigator.maybePop(context);
        _service.clickedIndex = index;

        var condition = index == widget.showBottomSheetAt && widget.bottomSheetHistory;

        _updateIndex(condition ? _tempIndex : index);
        if (condition) _service.clickedIndex = _tempIndex;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _service = Provider.of<Service>(context, listen: false);
    var size = MediaQuery.of(context).padding;

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
              visible: widget.visible,
              duration: widget.duration));

      if (!_isInit)
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 50));

          _service.setSelected(0);
          _isInit = true;
        });
    }

    if (_didUpdateWidget) {
      _updateIndex(widget.selected, didUpdateWidget: true);
      _didUpdateWidget = false;
    }

    return Visibility(
      key: ValueKey(1),
      visible: widget.visible,
      maintainState: true,
      maintainAnimation: true,
      child: Material(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(bottom: size.bottom),
          child: Container(
            height: kBottomNavigationBarHeight,
            child: Stack(
              children: [
                Container(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _service.items.map((e) => EmptyItem(e)).toList()),
                ),
                Container(
                  color: widget.backgroundColor ?? Colors.white,
                ),
                SlideBox(),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _service.items
                          .map((e) => NavItem(
                                e,
                                onTab: () {
                                  var index = _service.items.indexOf(e);

                                  if (index == widget.showBottomSheetAt)
                                    SSBottomSheet.show(context: context, child: widget.bottomSheetWidget, onPressed: _onPressed);
                                  else
                                    _tempIndex = index;

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

class SSBottomSheet extends StatefulWidget {
  final Color backgroundColor;
  final Widget child;
  final ValueChanged<Offset> onPressed;
  final double bottomMargin;

  SSBottomSheet({Key key, this.backgroundColor, this.child, this.onPressed, this.bottomMargin}) : super(key: key);

  @override
  _SSBottomSheetState createState() => _SSBottomSheetState();

  static show(
      {@required BuildContext context,
      @required child,
      backgroundColor = const Color(0xb3212121),
      double bottomMargin,
      ValueChanged<Offset> onPressed}) {
    Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          return SSBottomSheet(
            child: child,
            backgroundColor: backgroundColor,
            onPressed: onPressed,
            bottomMargin: bottomMargin,
          );
        },
        opaque: false));
  }
}

class _SSBottomSheetState extends State<SSBottomSheet> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  bool willPop = true;

  final GlobalKey _childKey = GlobalKey();

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  bool get _dismissUnderway => _animationController.status == AnimationStatus.reverse;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && willPop) _pop();
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _pop() {
    Navigator.pop(context);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) return;

    var change = details.primaryDelta / (_childHeight ?? details.primaryDelta);
    _animationController.value -= change;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) return;

    if (details.velocity.pixelsPerSecond.dy < 0) return;

    if (details.velocity.pixelsPerSecond.dy > 700) {
      final double flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (_animationController.value > 0.0) _animationController.fling(velocity: flingVelocity);
    } else if (_animationController.value < 0.5) {
      if (_animationController.value > 0.0) _animationController.fling(velocity: -1.0);
    } else
      _animationController.reverse();
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    if (_dismissUnderway) return;

    var box = context.findRenderObject() as RenderBox;
    var localOffset = box.globalToLocal(details.globalPosition);

    widget.onPressed.call(Offset(localOffset.dx, localOffset.dy));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var width = media.size.width;
    var bottomBarHeight = widget.bottomMargin ?? kBottomNavigationBarHeight + media.padding.bottom;

    return WillPopScope(
        onWillPop: onBackPressed,
        child: GestureDetector(
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          onTapDown: (TapDownDetails details) => onTapDown(context, details),
          child: Container(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                color: widget.backgroundColor,
                margin: EdgeInsets.only(bottom: bottomBarHeight),
                child: Column(
                  key: _childKey,
                  children: <Widget>[
                    Spacer(),
                    ClipRect(
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth,
                        child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, _) {
                              return Transform(
                                transform: Matrix4.translationValues(0.0, width * _animation.value, 0.0),
                                child: Container(
                                  width: width,
                                  child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () {}, child: widget.child),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          excludeFromSemantics: true,
        ));
  }

  Future<bool> onBackPressed() async {
    _animationController.reverse();
    return false;
  }
}
