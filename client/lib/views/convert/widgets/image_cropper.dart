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

class ImageCropper extends ConsumerStatefulWidget {
  final YoutubeInfo youtubeInfo;

  const ImageCropper({
    Key? key,
    required this.youtubeInfo,
  }) : super(key: key);

  @override
  _ImageCropperState createState() => _ImageCropperState();
}

class _ImageCropperState extends ConsumerState<ImageCropper> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey();

  final List<double?> _aspectRatios = [
    CropAspectRatios.ratio1_1,
    CropAspectRatios.ratio16_9,
    CropAspectRatios.ratio4_3,
    CropAspectRatios.original,
    CropAspectRatios.custom,
  ];

  final Map<double?, String> _cropRatioName = {
    CropAspectRatios.custom: 'None',
    CropAspectRatios.original: 'Original',
    CropAspectRatios.ratio16_9: '16:9',
    CropAspectRatios.ratio1_1: '1:1',
    CropAspectRatios.ratio3_4: '3:4',
    CropAspectRatios.ratio4_3: '4:3',
    CropAspectRatios.ratio9_16: '9:16',
  };

  int _selectedAspectRatio = 0;

  void _applyCrop() {
    ref.read(croppedImageProvider.notifier).convert(
          _editorKey.currentState?.image,
          _editorKey.currentState?.getCropRect(),
          _editorKey.currentState?.editAction?.needCrop,
        );
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
                    customDetails: stackTrace?.toString(),
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
                    loadStateChanged: (loadState) {
                      return Center(child: () {
                        switch (loadState.extendedImageLoadState) {
                          case LoadState.loading:
                            return const CupertinoActivityIndicator();
                          case LoadState.failed:
                            ref.read(croppedImageProvider.notifier).reset();
                            return ErrorText(
                              customText:
                                  'Error while trying to load the image!',
                              customDetails: loadState.lastStack?.toString(),
                            );
                          case LoadState.completed:
                            if (croppedImage.asData?.value == null) {
                              SchedulerBinding.instance.addPostFrameCallback(
                                (_) => setState(
                                  () {
                                    _applyCrop();
                                  },
                                ),
                              );
                            }
                            return loadState.completedWidget;
                          default:
                            return const Text('Unknown Error');
                        }
                      }());
                    },
                    initEditorConfigHandler: (state) => EditorConfig(
                      cornerColor: Theme.of(context).colorScheme.primary,
                      cornerSize: const Size(30, 4),
                      reverseMousePointerScrollDirection: true,
                      cropAspectRatio: _aspectRatios[_selectedAspectRatio],
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
                      _aspectRatios.mapIndexed(
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
                              label: Text(_cropRatioName[ratio] ?? 'None'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        if (editImage) {
                          _applyCrop();
                        } else {
                          ref.read(editImageProvider.notifier).state = true;
                        }
                      });
                    },
                    icon: Icon(
                      editImage
                          ? CupertinoIcons.floppy_disk
                          : CupertinoIcons.pencil,
                      size: 18,
                    ),
                    label: Text(editImage ? 'Save' : 'Edit'),
                    style: ElevatedButton.styleFrom(
                      primary: editImage ? CupertinoColors.activeGreen : null,
                    ),
                  )
                ],
              )
            : Container(),
      ],
    ).constrained;
  }
}
