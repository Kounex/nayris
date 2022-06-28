import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_info.freezed.dart';
part 'youtube_info.g.dart';

@freezed
class YoutubeInfo with _$YoutubeInfo {
  factory YoutubeInfo(
    String? uploader,
    String? title,
    String? description,
    List<int> thumbnailRAW,
    List<String> keywords,
    int? views,
    String? duration,
    String? published,
    String youtubeLink,
  ) = _YoutubeInfo;

  factory YoutubeInfo.fromJson(Map<String, dynamic> json) =>
      _$YoutubeInfoFromJson(json);
}
