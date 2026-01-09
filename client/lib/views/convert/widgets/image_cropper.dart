import 'dart:math';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/youtube_info/youtube_info.dart';
import '../../../providers/views/convert.dart';
import '../../../types/extensions/iterable.dart';
import '../../../types/extensions/widget.dart';
import '../../../widgets/general/error_text.dart';

List<double?> _kAspectRatios = [
  CropAspectRatios.ratio1_1,
  CropAspectRatios.ratio16_9,
  CropAspectRatios.ratio4_3,
  CropAspectRatios.original,
  CropAspectRatios.custom,
];

Map<double?, String> _kCropRatioName = {
  CropAspectRatios.custom: 'None',
  CropAspectRatios.original: 'Original',
  CropAspectRatios.ratio16_9: '16:9',
  CropAspectRatios.ratio1_1: '1:1',
  CropAspectRatios.ratio4_3: '4:3',
};

class ImageCropper extends ConsumerStatefulWidget {
  final YoutubeInfo youtubeInfo;

  const ImageCropper({
    super.key,
    required this.youtubeInfo,
  });

  @override
  _ImageCropperState createState() => _ImageCropperState();
}

class _ImageCropperState extends ConsumerState<ImageCropper> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey();

  int _selectedAspectRatio = 0;

  void _applyCrop() {
    ref.read(croppedImageProvider.notifier).convert(
          _editorKey.currentState?.image,
          _editorKey.currentState?.getCropRect(),
          _editorKey.currentState?.editAction?.needCrop,
        );
  }

  Widget _buildEditorState(ExtendedImageState loadState) {
    switch (loadState.extendedImageLoadState) {
      case LoadState.loading:
        return const CupertinoActivityIndicator();
      case LoadState.failed:
        ref.read(croppedImageProvider.notifier).reset();
        return ErrorText(
          customText: 'Error while trying to load the image!',
          customDetails: loadState.lastStack?.toString(),
        );
      case LoadState.completed:
        // We need to watch the provider here to react to its changes.
        final croppedImage = ref.watch(croppedImageProvider);
        if (croppedImage.asData?.value == null) {
          // Perform the initial crop after the first frame is built.
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => _applyCrop(),
          );
        }
        return loadState.completedWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    final croppedImage = ref.watch(croppedImageProvider);

    final editImage = ref.watch(editImageProvider);

    return Column(
      children: [
        SizedBox(
          height: min(
            max(
              MediaQuery.of(context).size.height / 2,
              250,
            ),
            500,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                maintainState: true,
                visible: !editImage,
                child: croppedImage.when(
                  loading: () => const CupertinoActivityIndicator(),
                  error: (exception, stackTrace) => ErrorText(
                    customText:
                        'Error while cropping the image, please try again!',
                    customDetails: stackTrace.toString(),
                  ),
                  data: (croppedImageData) => croppedImageData != null &&
                          croppedImageData.encodedPNG == null
                      ? const ErrorText(
                          customText:
                              'Error while loading the cropped image - it\'s not available after saving!',
                        )
                      : SizedBox.expand(
                          child: croppedImageData?.encodedPNG != null
                              ? Image.memory(
                                  Uint8List.fromList(
                                    croppedImageData!.encodedPNG!,
                                  ),
                                  fit: BoxFit.contain,
                                )
                              : Container(),
                        ),
                ),
              ),
              Visibility(
                maintainState: true,
                visible: editImage,
                child: ClipRect(
                  child: ExtendedImage.memory(
                    Uint8List.fromList(
                      this.widget.youtubeInfo.thumbnailRAW,
                    ),
                    extendedImageEditorKey: _editorKey,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    cacheRawData: true,
                    loadStateChanged: (loadState) =>
                        Center(child: _buildEditorState(loadState)),
                    initEditorConfigHandler: (state) => EditorConfig(
                      cornerColor: Theme.of(context).colorScheme.primary,
                      cornerSize: const Size(30, 4),
                      reverseMousePointerScrollDirection: true,
                      cropAspectRatio: _kAspectRatios[_selectedAspectRatio],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        croppedImage.asData?.value != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    runSpacing: 8.0,
                    spacing: 8.0,
                    children: List.from(
                      _kAspectRatios.mapIndexed(
                        (ratio, index) => ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            editImage ? Colors.white : Colors.grey.shade500,
                            BlendMode.modulate,
                          ),
                          child: GestureDetector(
                            onTap: editImage
                                ? () => setState(() {
                                      _selectedAspectRatio = index;
                                    })
                                : null,
                            child: Chip(
                              backgroundColor: index == _selectedAspectRatio
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              label: Text(_kCropRatioName[ratio] ?? 'None'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (editImage) {
                        _applyCrop();
                        ref.read(editImageProvider.notifier).state = false;
                      } else {
                        ref.read(editImageProvider.notifier).state = true;
                      }
                    },
                    icon: Icon(
                      editImage
                          ? CupertinoIcons.floppy_disk
                          : CupertinoIcons.pencil,
                      size: 18,
                    ),
                    label: Text(editImage ? 'Save' : 'Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          editImage ? CupertinoColors.activeGreen : null,
                    ),
                  )
                ],
              )
            : Container(),
      ],
    ).constrained;
  }
}
