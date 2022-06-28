import 'package:flutter/material.dart';

class NullableText extends StatelessWidget {
  final String? text;
  final String placeholder;
  final TextStyle? style;

  const NullableText(
    this.text, {
    Key? key,
    this.placeholder = 'Missing text',
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      this.text ?? this.placeholder,
      style: (this.style ?? Theme.of(context).textTheme.bodyText2!).copyWith(
        fontStyle: this.text == null ? FontStyle.italic : null,
      ),
    );
  }
}
