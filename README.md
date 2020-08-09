

# [ss_bottom_navbar](https://pub.dev/packages/ss_bottom_navbar)

![Publish to Pub.dev](https://github.com/NBK-Group/ss_bottom_navbar/workflows/Publish%20to%20Pub.dev/badge.svg)

Flutter modern bottom nav bar. Compatible with Android & iOS. You can customize it freely.

<img src="https://github.com/NBK-Group/ss_bottom_navbar/blob/master/images/showcase.gif?raw=true" width="300" />

## Getting Started

```yaml
dependencies:
  ss_bottom_navbar: 0.0.9
```

```bash
$  flutter pub get
```

```dart
import 'package:ss_bottom_navbar/ss_bottom_navbar.dart';
```

## Example

### SSBottomNav


##### Usage
```dart
var items = [
  SSBottomNavItem(text: 'Home', iconData: Icons.home),
  SSBottomNavItem(text: 'Store', iconData: Icons.store),
  SSBottomNavItem(text: 'Add', iconData: Icons.add, isIconOnly: true),
  SSBottomNavItem(text: 'Explore', iconData: Icons.explore),
  SSBottomNavItem(text: 'Profile', iconData: Icons.person),
];
```
```dart
SSBottomNav(
  items: items,
  color: Colors.black,
  selectedColor: Colors.white,
  unselectedColor: Colors.black,
  onTabSelected: (index) {
     print(index);
     setState(() {
        _index = index;
    });
  }
),
```
##### With bottom sheet dialog
```dart
SSBottomNav(
  items: items,
  color: Colors.black,
  selectedColor: Colors.white,
  unselectedColor: Colors.black,
  visible: isVisible,
  bottomSheetWidget: Container(),
  showBottomSheetAt: 2,
  onTabSelected: (index) {}
),
```
#### Customization

|Name|  Type| Description|
|--|--|--|
| `items` |`List<SSBottomNavItem>`| list of `SSBottomNavItem` items |
|`iconSize`| `double`| size of the icon on items |
| `backgroundColor`| `Color` | background color of the widget|
| `color`| `Color`| color of the slider |
| `selectedColor`| `Color`| items's color when selected |
| `unselectedColor`| `Color`| items's color when not selected |
| `onTabSelected`| `ValueChanged<int>`| function that returns the index on tab selected|
| `shadow`| `List<BoxShadow>`| shadow of the slider |
| `visible`| `bool`| visibilty of the `SSBottomNavItem` |
| `bottomSheetWidget`| `Widget`| child of the bottom sheet dialog |
| `showBottomSheetAt`| `int`| the index of `SSBottomNavItem` to show the `SSBottomNavItem` |
| `bottomSheetHistory`| `bool`| default `true`. option to go back previous tab if `showBottomSheetAt` pressed while `SSBottomSheet` showing |
| `dismissedByAnimation`| `ValueChanged<bool>`| function that returns true if `SSBottomSheet` dismissed by animation |

### SSBottomSheet

<img src="https://github.com/NBK-Group/ss_bottom_navbar/blob/master/images/showcase-bottom-sheet.png?raw=true" alt="SSBottomSheet Showcase Image" width="300" />

If you want to use `SSBottomNav`'s bottom sheet dialog, you can do that with `SSBottomSheet`
##### Usage
```dart
SSBottomSheet.show(
  context: context,
  child: bottomSheet(),
  onPressed: (offset) {}
);
```
```dart
bottomSheet() => Container(
  color: Colors.white,
  child: Column(
    children: [
      ListTile(
        leading: Icon(Icons.camera_alt),
        title: Text('Use Camera'),
      ),
      ListTile(
        leading: Icon(Icons.photo_library),
        title: Text('Choose from Gallery'),
      ),
      ListTile(
        leading: Icon(Icons.edit),
        title: Text('Write a Story'),
      ),
    ],
  ),
);
```
##### Dismiss the Bottom Sheet
```dart
Navigator.maybePop(context);
```
#### Customization

|Name|  Type| Description|
|--|--|--|
|`Widget`| `child`| child widget |
| `backgroundColor`| `Color` | background color of the widget|
| `bottomMargin`| `double`| margin from bottom acording to your bottom navbars height |
| `onPressed`| `ValueChanged<Offset>`| returns `Offset` when tapped |

## Contributions

Contributions of any kind are more than welcome! Feel free to fork and improve in any way you want, make a pull request, or open an issue.