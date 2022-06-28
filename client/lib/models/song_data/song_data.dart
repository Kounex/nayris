import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_data.freezed.dart';
part 'song_data.g.dart';

@freezed
class SongData with _$SongData {
  factory SongData(
    String? artist,
    String? title,
    String? album,
    String? year,
    List<int>? coverRAW,
    String youtubeLink,
  ) = _SongData;

  factory SongData.fromJson(Map<String, dynamic> json) =>
      _$SongDataFromJson(json);
}
