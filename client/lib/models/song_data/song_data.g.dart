// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SongData _$$_SongDataFromJson(Map<String, dynamic> json) => _$_SongData(
      json['artist'] as String?,
      json['title'] as String?,
      json['album'] as String?,
      json['year'] as String?,
      (json['coverRAW'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['youtubeLink'] as String,
    );

Map<String, dynamic> _$$_SongDataToJson(_$_SongData instance) =>
    <String, dynamic>{
      'artist': instance.artist,
      'title': instance.title,
      'album': instance.album,
      'year': instance.year,
      'coverRAW': instance.coverRAW,
      'youtubeLink': instance.youtubeLink,
    };
