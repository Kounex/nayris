import 'package:flutter/material.dart';

import '../../types/extensions/iterable.dart';
import '../animator/fade_in.dart';

class WebScaffold extends StatelessWidget {
  final Iterable<Widget> children;
  final bool fadeIn;
  final bool serialFadeIn;

  const WebScaffold({
    Key? key,
    required this.children,
    this.fadeIn = false,
    this.serialFadeIn = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) {
        // final rb = context.findRenderObject() as RenderBox;
        // final result = BoxHitTestResult();
        // rb.hitTest(result, position: e.position);

        // for (final e in result.path) {
        //   if (e.target is RenderEditable) {
        //     return;
        //   }
        // }

        // FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: this.fadeIn
                  ? SliverChildListDelegate.fixed(
                      List.from(
                        this.children.mapIndexed(
                              (child, index) => FadeInAnimator(
                                delay: Duration(milliseconds: 75 * index),
                                child: child,
                              ),
                            ),
                      ),
                    )
                  : SliverChildBuilderDelegate(
                      (context, index) => this.children.elementAt(index),
                      childCount: this.children.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
