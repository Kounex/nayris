import 'package:flutter/material.dart';

class FadeInAnimator extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration? delay;

  const FadeInAnimator({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 750),
    this.delay,
  }) : super(key: key);

  @override
  State<FadeInAnimator> createState() => _FadeInAnimatorState();
}

class _FadeInAnimatorState extends State<FadeInAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _opacity;
  late final Animation<Offset> _position;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: this.widget.duration);

    CurvedAnimation curved =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _position =
        Tween<Offset>(begin: const Offset(0, 0.1), end: const Offset(0, 0))
            .animate(curved);

    Future.delayed(
        this.widget.delay ?? Duration.zero, () => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        child: this.widget.child,
        builder: (context, child) => SlideTransition(
          position: _position,
          child: child!,
        ),
      ),
      builder: (context, child) => FadeTransition(
        opacity: _opacity,
        child: child!,
      ),
    );
  }
}
