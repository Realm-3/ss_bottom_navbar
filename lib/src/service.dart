library ss_bottom_navbar;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ss_bottom_navbar/src/ss_bottom_navbar.dart';

class SSBottomBarState extends ChangeNotifier {
  SSBottomNavBarSettings? settings;
  List<SSBottomNavItem> items = [];
  List<Offset?> sizes = [];
  List<Offset> sizesBig = [];
  List<Offset?> positions = [];
  List<Offset> positionsBig = [];
  List<GlobalKey> keys = [];

  int selected = 0;
  int clickedIndex = 0;

  Duration get animationDuration => settings!.duration ?? Duration(milliseconds: 300);
  SSBottomNavBarState state = SSBottomNavBarState.icon;
  int emptySelectedIndex = 0;

  void init(List<SSBottomNavItem> items, {SSBottomNavBarSettings? settings}) {
    this.settings = settings;
    this.items = items;
    sizes = this.items.map((e) => Offset.zero).toList();
    sizesBig = this.items.map((e) => Offset.zero).toList();
    positions = this.items.map((e) => Offset.zero).toList();
    positionsBig = this.items.map((e) => Offset.zero).toList();
    keys = this.items.map((e) => GlobalKey()).toList();
  }

  void setSizeAndPosition({required int index, Offset? size, Offset? position}) {
    sizes[index] = size;
    positions[index] = position;
    notifyListeners();
  }

  void setEmptySelectedIndex(int index) {
    emptySelectedIndex = index;
    notifyListeners();
  }

  Future<void> setSelected(int index, {bool didUpdateWidget = false}) async {
    selected = index;
    notifyListeners();

//    TODO: FEATURE
//    state = SSBottomNavBarState.icon;
//    notifyListeners();
//    await Future<void>.delayed(Duration(milliseconds: 1500));
//    setSizeAndPosition(
//        index: index,
//        size: Offset(keys[index].currentContext.size.width, keys[index].currentContext.size.height),
//        position: (keys[index].currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero));
//    await Future<void>.delayed(Duration(milliseconds: 1500));

    if (!didUpdateWidget) {
      selected = index;
      notifyListeners();
    }

    await Future<void>.delayed(Duration(milliseconds: 200));
    setSizeAndPosition(
        index: index,
        size: Offset(
            keys[index].currentContext!.size!.width, keys[index].currentContext!.size!.height),
        position: (keys[index].currentContext!.findRenderObject() as RenderBox)
            .localToGlobal(Offset.zero));

    await Future<void>.delayed(Duration(milliseconds: 200));
    setSizeAndPosition(
        index: index,
        size: Offset(
            keys[index].currentContext!.size!.width, keys[index].currentContext!.size!.height),
        position: (keys[index].currentContext!.findRenderObject() as RenderBox)
            .localToGlobal(Offset.zero));

    state = SSBottomNavBarState.text;
    notifyListeners();

    await Future<void>.delayed(Duration(milliseconds: 100));
    setSizeAndPosition(
        index: index,
        size: Offset(
            keys[index].currentContext!.size!.width, keys[index].currentContext!.size!.height),
        position: (keys[index].currentContext!.findRenderObject() as RenderBox)
            .localToGlobal(Offset.zero));
  }
}

enum SSBottomNavBarState { icon, text }

class SSBottomNavBarSettings {
  List<SSBottomNavItem>? items;
  double? iconSize;
  Color? backgroundColor;
  Color? color;
  Color? selectedColor;
  Color? unselectedColor;
  List<BoxShadow>? shadow;
  bool? isWidthFixed;
  Duration? duration;
  bool? visible;

  SSBottomNavBarSettings(
      {this.items,
      this.iconSize,
      this.backgroundColor,
      this.color,
      this.selectedColor,
      this.unselectedColor,
      this.shadow,
      this.isWidthFixed,
      this.visible,
      this.duration});
}
