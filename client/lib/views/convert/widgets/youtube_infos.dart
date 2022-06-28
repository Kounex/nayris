import 'package:flutter/material.dart';

import '../../../models/youtube_info/youtube_info.dart';
import '../../../widgets/general/nullable_text.dart';

class YoutubeInfos extends StatelessWidget {
  final YoutubeInfo youtubeInfo;

  const YoutubeInfos({
    Key? key,
    required this.youtubeInfo,
  }) : super(key: key);

  String? _formatNumber(int? number) {
    if (number != null) {
      String res = '';
      Characters chars = number.toString().characters;

      for (int i = chars.length; i > 0; i--) {
        if ((chars.length - i) > 0 && (chars.length - i) % 3 == 0) {
          res += '.';
        }
        res += chars.elementAt(i - 1);
      }

      return String.fromCharCodes(res.codeUnits.reversed);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NullableText(
                    this.youtubeInfo.title,
                    placeholder: 'No Title',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  NullableText(
                    this.youtubeInfo.uploader,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24.0),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: NullableText(
                this.youtubeInfo.published,
                placeholder: '-',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18.0),
        NullableText(
          this.youtubeInfo.description,
          placeholder: 'No Description',
        ),
        const SizedBox(height: 18.0),
        Row(
          children: [
            Expanded(
              child: NullableText(
                '${_formatNumber(this.youtubeInfo.views)} views',
                placeholder: '-',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            NullableText(
              this.youtubeInfo.duration,
              placeholder: '-',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        )
      ],
    );
  }
}
