import 'package:flutter/material.dart';

class BannerWrapper extends StatelessWidget {
  final Widget child;

  const BannerWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.symmetric(
          horizontal: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: this.child,
    );
  }
}
