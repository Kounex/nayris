import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/views/convert.dart';
import '../../types/extensions/widget.dart';
import '../../utils/overlay_handler.dart';
import '../../widgets/general/banner_wrapper.dart';
import '../../widgets/general/error_text.dart';
import '../../widgets/web/scaffold.dart';
import 'widgets/convert_fields.dart';
import 'widgets/convert_header.dart';
import 'widgets/image_cropper.dart';
import 'widgets/youtube_infos.dart';
import 'widgets/youtube_search_field.dart';

class ConvertView extends ConsumerWidget {
  const ConvertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<int>?>>(
      convertProvider,
      (previous, next) {
        next.when(
          data: (media) {
            OverlayHandler.closeAnyOverlay(immediately: false);
            final download = ref.watch(downloadProvider);

            if (media != null) {
              compute((_) {
                final content = base64Encode(media);
                AnchorElement(
                    href:
                        'data:application/octet-stream;charset=utf-16le;base64,$content')
                  ..setAttribute('download',
                      '${download?.songData.artist ?? "Unknown"} - ${download?.songData.title ?? "Unknown"}.mp3')
                  ..click();
              }, null);
            }
          },
          error: (exception, stackTrace) {
            OverlayHandler.closeAnyOverlay();
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Error while converting'),
                content: SingleChildScrollView(
                  child: ErrorText(
                    apiException: exception,
                    customDetails: stackTrace.toString(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          loading: () {
            final download = ref.watch(downloadProvider);

            return OverlayHandler.showStatusOverlay(
              context: context,
              showDuration: const Duration(seconds: 300),
              height: 200,
              width: 200,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CupertinoActivityIndicator(radius: 16.0),
                  download != null && download.downloadedCount > 0
                      ? LinearProgressIndicator(
                          value: download.totalCount / download.downloadedCount,
                        )
                      : const Text(
                          'Server is converting... Depending on the length of the video, this might take quite a while! Please wait patiently!',
                          textAlign: TextAlign.center,
                        ),
                ],
              ),
            );
          },
        );
      },
    );

    final youtubeVideoAV = ref.watch(youtubeVideoProvider);

    return WebScaffold(
      fadeIn: true,
      children: [
        const ConvertHeader(),
        const SizedBox(height: 32.0),
        SelectableText(
          'Yet another YouTube ripper. Enter a Youtube link (in whatever format, most importantly the "watch..." part at the end has to be present) and you will receive the video information which you can adjust to your liking before converting it.',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.justify,
        ).constrained,
        const SizedBox(height: 32.0),
        const YoutubeSearchField().constrained,
        const SizedBox(height: 32.0),
        youtubeVideoAV.when(
          loading: () => const CupertinoActivityIndicator().constrained,
          error: (exception, stackTrace) => ErrorText(
            apiException: exception,
            customText:
                'Error while searching for a Youtube video based on your link - try another one!',
            customDetails: exception.toString(),
          ).constrained,
          data: (youtubeInfo) => youtubeInfo != null
              ? Column(
                  children: [
                    BannerWrapper(
                      child: Column(
                        children: [
                          const SizedBox(height: 32.0),
                          ImageCropper(youtubeInfo: youtubeInfo),
                          const SizedBox(height: 32.0),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    YoutubeInfos(youtubeInfo: youtubeInfo).constrained,
                    const SizedBox(height: 24.0),
                    const Divider(
                      height: 0.0,
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 24.0),
                    ConvertFields(
                      youtubeInfo: youtubeInfo,
                      onDownload: (songData) {
                        ref.read(convertProvider.notifier).convert(songData);
                      },
                    ).constrained,
                  ],
                )
              : Container(),
        ),
        const SizedBox(height: 64.0),
      ],
    );
  }
}
