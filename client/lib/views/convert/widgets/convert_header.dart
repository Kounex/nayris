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
        child: Image.asset(
          'assets/images/logo.png',
        ).constrained,
      ),
    );
  }
}
