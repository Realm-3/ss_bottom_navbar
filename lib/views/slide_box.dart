import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service.dart';

class SlideBox extends StatefulWidget {
  @override
  _SlideBoxState createState() => _SlideBoxState();
}

class _SlideBoxState extends State<SlideBox> with TickerProviderStateMixin {
  double _height = 40;

  @override
  Widget build(BuildContext context) {
    var _service = Provider.of<Service>(context);

    var _sizeFactor = 4;
    var _topPadding = (kBottomNavigationBarHeight - _height) / 2;

    var _sizeX = _service.items[_service.selected].isIconOnly
        ? _service.sizes[_service.selected].dx
        : _service.settings.isWidthFixed
            ? _service.sizesBig.reduce((curr, next) => curr.dx > next.dx ? curr : next).dx
            : _service.state == SSBottomNavBarState.text ? _service.sizesBig[_service.selected].dx : _service.sizes[_service.selected].dx;
    var _posX = _service.state == SSBottomNavBarState.text ? _service.positionsBig[_service.selected].dx : _service.positions[_service.selected].dx;

    var _width = _sizeX + _sizeFactor * 2;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: kBottomNavigationBarHeight,
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            left: _posX - _sizeFactor,
            child: Container(
              child: AnimatedSize(
                curve: Curves.ease,
                child: new Container(
                  padding: EdgeInsets.symmetric(vertical: _topPadding),
                  alignment: Alignment.center,
                  child: Container(
                    width: _width,
                    height: _height,
                    decoration: BoxDecoration(
                        color: _service.settings.color,
//                        border: Border.all(color: Colors.red, width: 5),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: _service.settings.shadow ??
                            [BoxShadow(offset: Offset(0, 3), blurRadius: 6, color: const Color(0xff000000).withOpacity(0.16))]),
                  ),
                ),
                vsync: this,
                duration: _service.animationDuration,
              ),
            ),
            duration: _service.animationDuration,
            curve: Curves.easeOutCirc,
          ),
        ],
      ),
    );
  }
}
