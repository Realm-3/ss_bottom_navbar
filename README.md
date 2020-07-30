# ss_bottom_navbar

Flutter modern bottom nav bar. Compatible with Android & iOS. You can customize it freely.

<img src="https://github.com/NBK-Group/ss_bottom_navbar/blob/master/images/showcase.gif?raw=true" width="300" />

## Getting Started

```yaml
dependencies:
  ss_bottom_navbar: ^0.0.1
```

```bash
$  flutter pub get
```

```dart
import 'package:ss_bottom_navbar/ss_bottom_navbar.dart';
```

## Example

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
## Customization

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

## Contributions

Contributions of any kind are more than welcome! Feel free to fork and improve in any way you want, make a pull request, or open an issue.
