// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$YoutubeImpl _$$YoutubeImplFromJson(Map<String, dynamic> json) =>
    _$YoutubeImpl(
      id: json['id'] as String,
      snippet: Snippet.fromJson(json['snippet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$YoutubeImplToJson(_$YoutubeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'snippet': instance.snippet,
    };
