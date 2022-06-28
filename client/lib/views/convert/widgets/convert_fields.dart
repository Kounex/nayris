import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/song_data/song_data.dart';
import '../../../models/youtube_info/youtube_info.dart';
import '../../../providers/views/convert.dart';
import '../../../widgets/general/styled_text_field.dart';

class ConvertFields extends ConsumerStatefulWidget {
  final YoutubeInfo youtubeInfo;
  final void Function(SongData)? onDownload;

  const ConvertFields({
    Key? key,
    required this.youtubeInfo,
    this.onDownload,
  }) : super(key: key);

  @override
  _ConvertFieldsState createState() => _ConvertFieldsState();
}

class _ConvertFieldsState extends ConsumerState<ConvertFields> {
  late final TextEditingController _artist;
  late final TextEditingController _title;
  late final TextEditingController _album;
  late final TextEditingController _year;

  @override
  void initState() {
    super.initState();

    _artist = TextEditingController(text: this.widget.youtubeInfo.uploader);
    _title = TextEditingController(text: this.widget.youtubeInfo.title);
    _album = TextEditingController();
    _year = TextEditingController();
  }

  SongData _createSongData() => SongData(
        _artist.text.trim(),
        _title.text.trim(),
        _album.text.trim(),
        _year.text.trim(),
        ref.read(croppedImageProvider).value?.encodedPNG,
        ref.read(youtubeVideoProvider).value!.youtubeLink,
      );

  @override
  Widget build(BuildContext context) {
    final editImage = ref.watch(editImageProvider);

    return Column(
      children: [
        StyledTextField(
          controller: _artist,
          label: 'Artist',
        ),
        StyledTextField(
          controller: _title,
          label: 'Title',
        ),
        StyledTextField(
          controller: _album,
          label: 'Album',
        ),
        StyledTextField(
          controller: _year,
          label: 'Year',
        ),
        const SizedBox(
          height: 48.0,
        ),
        SizedBox(
          height: 38.0,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: !editImage
                ? () {
                    if (ref.read(croppedImageProvider).value?.encodedPNG ==
                        null) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Details'),
                          content: const SelectableText(
                            'No cover image is present - probably an error while trying to parse the YouTube thumbnail. You can still convert and download the video but the output will not have a cover image!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                this.widget.onDownload?.call(_createSongData());
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      this.widget.onDownload?.call(_createSongData());
                    }
                  }
                : null,
            icon: const Icon(Icons.download),
            label: Text(
              'Download',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}
