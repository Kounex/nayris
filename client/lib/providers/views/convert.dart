import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as image;

import '../../models/song_data/song_data.dart';
import '../../models/youtube_info/youtube_info.dart';
import '../../types/classes/convert_data.dart';
import '../../types/classes/cropped_image_data.dart';
import '../shared/dio.dart';

class YoutubeVideoRepository extends StateNotifier<AsyncValue<YoutubeInfo?>> {
  final Ref ref;

  YoutubeVideoRepository(this.ref) : super(const AsyncValue.data(null));

  void reset() => state = const AsyncValue.data(null);

  Future<void> fetch(String videoURL) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);

      final response =
          await dio.post('/fetch', data: {'videoFragment': videoURL});

      return YoutubeInfo.fromJson(response.data);
    });
  }
}

class CroppedImageRepository
    extends StateNotifier<AsyncValue<CroppedImageData?>> {
  final Ref ref;

  CroppedImageRepository(this.ref) : super(const AsyncValue.data(null));

  void reset() => state = const AsyncValue.data(null);

  Future<void> convert(ui.Image? img, ui.Rect? cropRect, bool? needCrop) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      if (img != null) {
        return compute<ui.Image, CroppedImageData>((img) async {
          ByteData? byteData =
              await img.toByteData(format: ui.ImageByteFormat.png);

          Uint8List rawData =
              byteData!.buffer.asUint8List(byteData.offsetInBytes);

          image.Image? convImage = image.decodePng(rawData);

          if (convImage != null &&
              cropRect != null &&
              needCrop != null &&
              needCrop) {
            convImage = image.copyCrop(
              convImage,
              cropRect.left.toInt(),
              cropRect.top.toInt(),
              cropRect.width.toInt(),
              cropRect.height.toInt(),
            );
          }

          return CroppedImageData(
            convImage != null ? image.encodePng(convImage) : null,
            cropRect,
            convImage?.height,
            convImage?.width,
          );
        }, img);
      }
      return null;
    });

    ref.read(editImageProvider.notifier).state = false;
  }
}

class ConvertRepository extends StateNotifier<AsyncValue<List<int>?>> {
  final Ref ref;

  ConvertRepository(this.ref) : super(const AsyncValue.data(null));

  void reset() => state = const AsyncValue.data(null);

  Future<void> convert(SongData songData) async {
    state = const AsyncValue.loading();

    ref.read(downloadProvider.notifier).state = ConvertData(songData);

    state = await AsyncValue.guard(() async {
      final res = await ref.read(dioProvider).post(
            '/convert',
            data: songData,
            options: Options(
              responseType: ResponseType.bytes,
            ),
            onReceiveProgress: (count, total) => ref
                .read(downloadProvider.notifier)
                .state = ConvertData.all(songData, count, total),
          );

      return res.data;
    });
  }
}

final youtubeVideoProvider = StateNotifierProvider.autoDispose<
    YoutubeVideoRepository, AsyncValue<YoutubeInfo?>>(
  (ref) => YoutubeVideoRepository(ref),
);

final croppedImageProvider = StateNotifierProvider.autoDispose<
    CroppedImageRepository, AsyncValue<CroppedImageData?>>(
  (ref) => CroppedImageRepository(ref),
);

final convertProvider = StateNotifierProvider.autoDispose<ConvertRepository,
    AsyncValue<List<int>?>>(
  (ref) => ConvertRepository(ref),
);

final downloadProvider = StateProvider<ConvertData?>((_) => null);

final editImageProvider = StateProvider.autoDispose<bool>((_) => true);
