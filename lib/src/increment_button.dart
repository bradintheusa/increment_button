import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum IncrementButtonPosition {
  veryFarLeft,
  farLeft,
  left,
  center,
  right,
  farRight,
  veryFarRight
}

class IncrementButton extends StatefulWidget {

  // I've kept the interface light and made it just what I need. If you need
  // to add something just make a pull reqest.


  /// Label of the button.
  final Widget? label;

  /// The color of button.
  ///
  /// If null, it will be transparent.
  final Color? buttonColor;

  /// The color of background.
  ///
  /// If null, it will be transparent.
  final Color? color;

  /// Border of area slide (usually called background).
  final BoxBorder? border;

  /// Border Radius for the button and it's child.
  ///
  /// Default value is `const BorderRadius.all(const Radius.circular(60.0))`
  final BorderRadius borderRadius =
      const BorderRadius.all(Radius.circular(60.0));

  /// The height of this widget (button and it's background).
  ///
  /// Default value is 36.0.
  final double height;

  /// Width of area slide (usually called background).
  ///
  /// Default value is 120.0.
  final double width;

  /// Width of button. If [buttonWidth] is still null and the [label] is not null, this will automatically wrapping [label].
  ///
  /// The minimum size is [height], and the maximum size is three quarters from [width].
  final double? buttonWidth;

  /// You must set this to get notifcations of changes..
  final ValueChanged<int> onDelta;

  /// Controller for the button while sliding.
  final AnimationController? controller;


  /// Creates a [IncrementButton]
  IncrementButton({
    Key? key,
    required this.onDelta,
    this.controller,
    this.buttonColor,
    this.color,
    this.label,
    this.border,
    this.height = 36.0,
    this.width = 80.0,
    this.buttonWidth,
  }) : super(key: key);

  @override
  _IncrementButtonState createState() => _IncrementButtonState();
}

class _IncrementButtonState extends State<IncrementButton>
    with SingleTickerProviderStateMixin {
  Timer? _delayTimer;
  // the time you need to hold still for.
  Duration _delay = Duration(milliseconds: 450);
  int segments = 7;
  IncrementButtonPosition _previousPosition = IncrementButtonPosition.center;

  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _positionedKey = GlobalKey();

  late final AnimationController _controller;
  Offset _start = Offset.zero;

  RenderBox? get _positioned =>
      _positionedKey.currentContext!.findRenderObject() as RenderBox?;

  RenderBox? get _container =>
      _containerKey.currentContext!.findRenderObject() as RenderBox?;

  double get _buttonWidth {
    if ((widget.buttonWidth ?? double.minPositive) > widget.width * 3 / 4) {
      return widget.width * 3 / 4;
    }
    if (widget.buttonWidth != null) return widget.buttonWidth!;
    return double.minPositive;
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        AnimationController.unbounded(
            vsync: this, duration: Duration(milliseconds: 150));
    _controller.value = 0.5;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: widget.border,
        borderRadius: widget.borderRadius,
      ),
      child: Stack(
        key: _containerKey,
        children: <Widget>[
          DecoratedBox(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: widget.borderRadius,
              ),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 6, left: 8, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FaIcon(FontAwesomeIcons.angleLeft,color: Colors.black87),
                      FaIcon(FontAwesomeIcons.angleLeft, color: Colors.black45),
                      FaIcon(FontAwesomeIcons.angleLeft, color: Colors.black26),
                      FaIcon(FontAwesomeIcons.angleRight,color: Colors.black26),
                      FaIcon(FontAwesomeIcons.angleRight,color: Colors.black45),
                      FaIcon(FontAwesomeIcons.angleRight,
                          color: Colors.black87),
                    ],
                  ),
                ),
              )),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Align(
              alignment: Alignment((_controller.value * 2.0) - 1.0, 0.0),
              child: child,
            ),
            child: Container(
              key: _positionedKey,
              constraints: BoxConstraints(
                minWidth: widget.height,
                maxWidth: widget.width * 3 / 4,
              ),
              width: _buttonWidth,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: widget.buttonColor,
              ),
              child: GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: Center(child: widget.label),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    final pos = _positioned!.globalToLocal(details.globalPosition);
    _start = Offset(pos.dx, 0.0);
    _controller.stop(canceled: true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final pos = _container!.globalToLocal(details.globalPosition) - _start;
    final extent = _container!.size.width - _positioned!.size.width;
    _controller.value = (pos.dx.clamp(0.0, extent) / extent);

    // print(_controller.value.toString());
    _emit(_controller.value);
  }

  void _onDragEnd(DragEndDetails details) {
    _controller.animateTo(0.5);
  }

  _emit(double value) {
    IncrementButtonPosition _position = _rangeToPosition(value);

    if (_position == IncrementButtonPosition.center) {
      if (_delayTimer == null) {
        return;
      } else {
        _delayTimer!.cancel();
        return;
      }
    }

    if (_position == _previousPosition) {
      return;
    }

    _position = _previousPosition;

    if (_delayTimer != null) {
      _delayTimer!.cancel();
    }

    _delayTimer = Timer(_delay, _callEmitEvent);
  }

  _callEmitEvent() {
    IncrementButtonPosition p = _rangeToPosition(_controller.value);
    int delta = 0;
    switch (p) {
      case IncrementButtonPosition.veryFarLeft:
        delta = -10;
        break;
      case IncrementButtonPosition.farLeft:
        delta = -5;
        break;
      case IncrementButtonPosition.left:
        delta = -1;
        break;
      case IncrementButtonPosition.right:
        delta = 1;
        break;
      case IncrementButtonPosition.farRight:
        delta = 5;
        break;
      case IncrementButtonPosition.veryFarRight:
        delta = 10;
        break;

      default:
        delta = 0;
    }
    if (!_controller.isAnimating) {
      widget.onDelta(delta);
    }
    _emit(_controller.value);
  }

  IncrementButtonPosition _rangeToPosition(double pos) {
    if (pos < 1 / segments) {
      return IncrementButtonPosition.veryFarLeft;
    }
    if (pos < 2 / segments) {
      return IncrementButtonPosition.farLeft;
    }
    if (pos < 3 / segments) {
      return IncrementButtonPosition.left;
    }
    if (pos < 4 / segments) {
      return IncrementButtonPosition.center;
    }
    if (pos < 5 / segments) {
      return IncrementButtonPosition.right;
    }
    if (pos < 6 / segments) {
      return IncrementButtonPosition.farRight;
    }
    return IncrementButtonPosition.veryFarRight;
  }
}
