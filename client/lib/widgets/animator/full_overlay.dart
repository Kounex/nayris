import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class FullOverlay extends StatefulWidget {
  final Widget content;
  final Duration animationDuration;
  final Duration showDuration;

  final double height;
  final double width;

  const FullOverlay({
    Key? key,
    required this.content,
    required this.animationDuration,
    required this.showDuration,
    double? height,
    double? width,
  })  : height = height ?? 150.0,
        width = width ?? 150.0,
        super(key: key);

  @override
  FullOverlayState createState() => FullOverlayState();
}

class FullOverlayState extends State<FullOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blur;
  late Animation<double> _opacity;

  late Timer _closeTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: this.widget.animationDuration);
    _blur = Tween<double>(begin: 0.001, end: 9.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));
    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));

    _controller.forward();
    _closeTimer = Timer(this.widget.showDuration, () => this.closeOverlay());
  }

  Future<void> closeOverlay() async {
    _closeTimer.cancel();
    if (this.mounted) {
      await _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: AnimatedBuilder(
            animation: _controller,
            child: const AbsorbPointer(),
            builder: (context, child) => FadeTransition(
              opacity: _opacity,
              child: Container(
                child: child,
                color: Colors.black26,
              ),
            ),
          ),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height / 2) -
              (this.widget.height / 2),
          left:
              (MediaQuery.of(context).size.width / 2) - (this.widget.width / 2),
          child: Material(
            type: MaterialType.transparency,
            child: AnimatedBuilder(
                animation: _controller,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: this.widget.content,
                ),
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: _blur.value, sigmaY: _blur.value),
                    child: FadeTransition(
                      opacity: _opacity,
                      child: Container(
                        height: this.widget.height,
                        width: this.widget.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black87
                              : Colors.white70,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: child,
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
