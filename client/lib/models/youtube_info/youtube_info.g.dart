// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_YoutubeInfo _$$_YoutubeInfoFromJson(Map<String, dynamic> json) =>
    _$_YoutubeInfo(
      json['uploader'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      (json['thumbnailRAW'] as List<dynamic>).map((e) => e as int).toList(),
      (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      json['views'] as int?,
      json['duration'] as String?,
      json['published'] as String?,
      json['youtubeLink'] as String,
    );

Map<String, dynamic> _$$_YoutubeInfoToJson(_$_YoutubeInfo instance) =>
    <String, dynamic>{
      'uploader': instance.uploader,
      'title': instance.title,
      'description': instance.description,
      'thumbnailRAW': instance.thumbnailRAW,
      'keywords': instance.keywords,
      'views': instance.views,
      'duration': instance.duration,
      'published': instance.published,
      'youtubeLink': instance.youtubeLink,
    };
