import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyledTextField extends StatefulWidget {
  final TextEditingController? controller;

  final String? label;

  final bool deleteSuffix;
  final Widget? suffix;

  final void Function()? onDeleteSuffixPressed;
  final void Function()? onEditingComplete;

  const StyledTextField({
    Key? key,
    this.controller,
    this.label,
    this.deleteSuffix = true,
    this.suffix,
    this.onDeleteSuffixPressed,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  _StyledTextFieldState createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = this.widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller..addListener(() => setState(() {})),
      mouseCursor: SystemMouseCursors.text,
      onEditingComplete: this.widget.onEditingComplete,
      decoration: InputDecoration(
        filled: true,
        labelText: this.widget.label,
        suffix: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            this.widget.deleteSuffix
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: _controller.text.isNotEmpty
                            ? () {
                                this.widget.onDeleteSuffixPressed?.call();
                                _controller.clear();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(
                          CupertinoIcons.clear,
                          size: 16.0,
                        ),
                      ),
                    ),
                  )
                : Container(),
            this.widget.suffix ?? Container(),
          ],
        ),
      ),
    );
  }
}
