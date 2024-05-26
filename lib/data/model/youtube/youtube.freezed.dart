// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Youtube _$YoutubeFromJson(Map<String, dynamic> json) {
  return _Youtube.fromJson(json);
}

/// @nodoc
mixin _$Youtube {
  String get id => throw _privateConstructorUsedError;
  Snippet get snippet => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $YoutubeCopyWith<Youtube> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YoutubeCopyWith<$Res> {
  factory $YoutubeCopyWith(Youtube value, $Res Function(Youtube) then) =
      _$YoutubeCopyWithImpl<$Res, Youtube>;
  @useResult
  $Res call({String id, Snippet snippet});

  $SnippetCopyWith<$Res> get snippet;
}

/// @nodoc
class _$YoutubeCopyWithImpl<$Res, $Val extends Youtube>
    implements $YoutubeCopyWith<$Res> {
  _$YoutubeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? snippet = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      snippet: null == snippet
          ? _value.snippet
          : snippet // ignore: cast_nullable_to_non_nullable
              as Snippet,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SnippetCopyWith<$Res> get snippet {
    return $SnippetCopyWith<$Res>(_value.snippet, (value) {
      return _then(_value.copyWith(snippet: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$YoutubeImplCopyWith<$Res> implements $YoutubeCopyWith<$Res> {
  factory _$$YoutubeImplCopyWith(
          _$YoutubeImpl value, $Res Function(_$YoutubeImpl) then) =
      __$$YoutubeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, Snippet snippet});

  @override
  $SnippetCopyWith<$Res> get snippet;
}

/// @nodoc
class __$$YoutubeImplCopyWithImpl<$Res>
    extends _$YoutubeCopyWithImpl<$Res, _$YoutubeImpl>
    implements _$$YoutubeImplCopyWith<$Res> {
  __$$YoutubeImplCopyWithImpl(
      _$YoutubeImpl _value, $Res Function(_$YoutubeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? snippet = null,
  }) {
    return _then(_$YoutubeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      snippet: null == snippet
          ? _value.snippet
          : snippet // ignore: cast_nullable_to_non_nullable
              as Snippet,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$YoutubeImpl implements _Youtube {
  const _$YoutubeImpl({required this.id, required this.snippet});

  factory _$YoutubeImpl.fromJson(Map<String, dynamic> json) =>
      _$$YoutubeImplFromJson(json);

  @override
  final String id;
  @override
  final Snippet snippet;

  @override
  String toString() {
    return 'Youtube(id: $id, snippet: $snippet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YoutubeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.snippet, snippet) || other.snippet == snippet));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, snippet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$YoutubeImplCopyWith<_$YoutubeImpl> get copyWith =>
      __$$YoutubeImplCopyWithImpl<_$YoutubeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$YoutubeImplToJson(
      this,
    );
  }
}

abstract class _Youtube implements Youtube {
  const factory _Youtube(
      {required final String id,
      required final Snippet snippet}) = _$YoutubeImpl;

  factory _Youtube.fromJson(Map<String, dynamic> json) = _$YoutubeImpl.fromJson;

  @override
  String get id;
  @override
  Snippet get snippet;
  @override
  @JsonKey(ignore: true)
  _$$YoutubeImplCopyWith<_$YoutubeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
