import 'package:flutter/material.dart';
import 'package:ss_bottom_navbar/ss_bottom_navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SS Bottom NavBar Example App",
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _index = 0;

  var _colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.teal];
  var items = [
    SSBottomNavItem(text: 'Home', iconData: Icons.home),
    SSBottomNavItem(text: 'Store', iconData: Icons.store),
    SSBottomNavItem(text: 'Add', iconData: Icons.add, isIconOnly: true),
    SSBottomNavItem(text: 'Explore', iconData: Icons.explore),
    SSBottomNavItem(text: 'Profile', iconData: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    _page(Color color) => Container(color: color);

    _buildPages() => _colors.map((color) => _page(color)).toList();

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _buildPages(),
      ),
      bottomNavigationBar:
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
        },
      ),
    );
  }
}
