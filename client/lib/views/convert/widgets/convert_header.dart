import 'package:flutter/material.dart';

import '../../../types/extensions/widget.dart';
import '../../../widgets/general/banner_wrapper.dart';

class ConvertHeader extends StatelessWidget {
  const ConvertHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BannerWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0),
        child: Column(
          children: [
            Text(
              'NAYRIS',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              'Not another YouTube ripper I swear',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ).constrained,
      ),
    );
  }
}
