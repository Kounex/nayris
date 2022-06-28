// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'song_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SongData _$SongDataFromJson(Map<String, dynamic> json) {
  return _SongData.fromJson(json);
}

/// @nodoc
class _$SongDataTearOff {
  const _$SongDataTearOff();

  _SongData call(String? artist, String? title, String? album, String? year,
      List<int>? coverRAW, String youtubeLink) {
    return _SongData(
      artist,
      title,
      album,
      year,
      coverRAW,
      youtubeLink,
    );
  }

  SongData fromJson(Map<String, Object?> json) {
    return SongData.fromJson(json);
  }
}

/// @nodoc
const $SongData = _$SongDataTearOff();

/// @nodoc
mixin _$SongData {
  String? get artist => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get album => throw _privateConstructorUsedError;
  String? get year => throw _privateConstructorUsedError;
  List<int>? get coverRAW => throw _privateConstructorUsedError;
  String get youtubeLink => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongDataCopyWith<SongData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongDataCopyWith<$Res> {
  factory $SongDataCopyWith(SongData value, $Res Function(SongData) then) =
      _$SongDataCopyWithImpl<$Res>;
  $Res call(
      {String? artist,
      String? title,
      String? album,
      String? year,
      List<int>? coverRAW,
      String youtubeLink});
}

/// @nodoc
class _$SongDataCopyWithImpl<$Res> implements $SongDataCopyWith<$Res> {
  _$SongDataCopyWithImpl(this._value, this._then);

  final SongData _value;
  // ignore: unused_field
  final $Res Function(SongData) _then;

  @override
  $Res call({
    Object? artist = freezed,
    Object? title = freezed,
    Object? album = freezed,
    Object? year = freezed,
    Object? coverRAW = freezed,
    Object? youtubeLink = freezed,
  }) {
    return _then(_value.copyWith(
      artist: artist == freezed
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      album: album == freezed
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String?,
      year: year == freezed
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      coverRAW: coverRAW == freezed
          ? _value.coverRAW
          : coverRAW // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      youtubeLink: youtubeLink == freezed
          ? _value.youtubeLink
          : youtubeLink // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$SongDataCopyWith<$Res> implements $SongDataCopyWith<$Res> {
  factory _$SongDataCopyWith(_SongData value, $Res Function(_SongData) then) =
      __$SongDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? artist,
      String? title,
      String? album,
      String? year,
      List<int>? coverRAW,
      String youtubeLink});
}

/// @nodoc
class __$SongDataCopyWithImpl<$Res> extends _$SongDataCopyWithImpl<$Res>
    implements _$SongDataCopyWith<$Res> {
  __$SongDataCopyWithImpl(_SongData _value, $Res Function(_SongData) _then)
      : super(_value, (v) => _then(v as _SongData));

  @override
  _SongData get _value => super._value as _SongData;

  @override
  $Res call({
    Object? artist = freezed,
    Object? title = freezed,
    Object? album = freezed,
    Object? year = freezed,
    Object? coverRAW = freezed,
    Object? youtubeLink = freezed,
  }) {
    return _then(_SongData(
      artist == freezed
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String?,
      title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      album == freezed
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String?,
      year == freezed
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      coverRAW == freezed
          ? _value.coverRAW
          : coverRAW // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      youtubeLink == freezed
          ? _value.youtubeLink
          : youtubeLink // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SongData implements _SongData {
  _$_SongData(this.artist, this.title, this.album, this.year, this.coverRAW,
      this.youtubeLink);

  factory _$_SongData.fromJson(Map<String, dynamic> json) =>
      _$$_SongDataFromJson(json);

  @override
  final String? artist;
  @override
  final String? title;
  @override
  final String? album;
  @override
  final String? year;
  @override
  final List<int>? coverRAW;
  @override
  final String youtubeLink;

  @override
  String toString() {
    return 'SongData(artist: $artist, title: $title, album: $album, year: $year, coverRAW: $coverRAW, youtubeLink: $youtubeLink)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SongData &&
            const DeepCollectionEquality().equals(other.artist, artist) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.album, album) &&
            const DeepCollectionEquality().equals(other.year, year) &&
            const DeepCollectionEquality().equals(other.coverRAW, coverRAW) &&
            const DeepCollectionEquality()
                .equals(other.youtubeLink, youtubeLink));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(artist),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(album),
      const DeepCollectionEquality().hash(year),
      const DeepCollectionEquality().hash(coverRAW),
      const DeepCollectionEquality().hash(youtubeLink));

  @JsonKey(ignore: true)
  @override
  _$SongDataCopyWith<_SongData> get copyWith =>
      __$SongDataCopyWithImpl<_SongData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SongDataToJson(this);
  }
}

abstract class _SongData implements SongData {
  factory _SongData(String? artist, String? title, String? album, String? year,
      List<int>? coverRAW, String youtubeLink) = _$_SongData;

  factory _SongData.fromJson(Map<String, dynamic> json) = _$_SongData.fromJson;

  @override
  String? get artist;
  @override
  String? get title;
  @override
  String? get album;
  @override
  String? get year;
  @override
  List<int>? get coverRAW;
  @override
  String get youtubeLink;
  @override
  @JsonKey(ignore: true)
  _$SongDataCopyWith<_SongData> get copyWith =>
      throw _privateConstructorUsedError;
}
