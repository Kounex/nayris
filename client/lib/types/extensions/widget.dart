import 'package:flutter/material.dart';

extension WidgetStuff on Widget {
  /// Wraps the [Widget] inside a [ConstrainedBox] to enforce
  /// a max width as used for containers in the web environment
  Widget get constrained => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 768.0),
            child: this,
          ),
        ),
      );
}
