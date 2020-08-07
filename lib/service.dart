import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ss_bottom_navbar/ss_bottom_navbar.dart';

class Service extends ChangeNotifier {
  SSBottomNavBarSettings settings;
  List<SSBottomNavItem> items = [];
  List<Offset> sizes = [];
  List<Offset> sizesBig = [];
  List<Offset> positions = [];
  List<Offset> positionsBig = [];
  List<GlobalKey> keys = [];

  bool willPop = false;

  set setWillPop(bool b) {
    willPop = b;
    notifyListeners();
  }

  int selected = 0;
  int clickedIndex = 0;

  get animationDuration => settings.duration ?? Duration(milliseconds: 300);
  var state = SSBottomNavBarState.icon;
  var emptySelectedIndex = 0;

  init(List<SSBottomNavItem> items, {SSBottomNavBarSettings settings}) {
    this.settings = settings;
    this.items = items;
    sizes = this.items.map((e) => Offset.zero).toList();
    sizesBig = this.items.map((e) => Offset.zero).toList();
    positions = this.items.map((e) => Offset.zero).toList();
    positionsBig = this.items.map((e) => Offset.zero).toList();
    keys = this.items.map((e) => GlobalKey()).toList();
  }

  setSizeAndPosition({int index, Offset size, Offset position}) {
    sizes[index] = size;
    positions[index] = position;
    notifyListeners();
  }

  setEmptySelectedIndex(int index) {
    emptySelectedIndex = index;
    notifyListeners();
  }

  setSelected(int index, {bool didUpdateWidget = false}) async {
//    TODO: FEATURE
//    state = SSBottomNavBarState.icon;
//    notifyListeners();
//    await Future.delayed(Duration(milliseconds: 1500));
//    setSizeAndPosition(
//        index: index,
//        size: Offset(keys[index].currentContext.size.width, keys[index].currentContext.size.height),
//        position: (keys[index].currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero));
//    await Future.delayed(Duration(milliseconds: 1500));

    if (!didUpdateWidget) {
      selected = index;
      notifyListeners();
    }
    await Future.delayed(Duration(milliseconds: 200));
    setSizeAndPosition(
        index: index,
        size: Offset(keys[index].currentContext.size.width, keys[index].currentContext.size.height),
        position: (keys[index].currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero));

    await Future.delayed(Duration(milliseconds: 200));
    setSizeAndPosition(
        index: index,
        size: Offset(keys[index].currentContext.size.width, keys[index].currentContext.size.height),
        position: (keys[index].currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero));

    state = SSBottomNavBarState.text;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 100));
    setSizeAndPosition(
        index: index,
        size: Offset(keys[index].currentContext.size.width, keys[index].currentContext.size.height),
        position: (keys[index].currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero));
  }
}

enum SSBottomNavBarState { icon, text }

class SSBottomNavBarSettings {
  List<SSBottomNavItem> items;
  double iconSize;
  Color backgroundColor;
  Color color;
  Color selectedColor;
  Color unselectedColor;
  ValueChanged<int> onTabSelected;
  List<BoxShadow> shadow;
  int selected;
  bool isWidthFixed;
  Duration duration;
  bool visible;

  SSBottomNavBarSettings(
      {this.items,
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
      this.duration});
}
