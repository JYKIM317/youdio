import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youdio/data/model/snippet/snippet.dart';

part 'youtube.freezed.dart';
part 'youtube.g.dart';

@freezed
class Youtube with _$Youtube {
  const factory Youtube({
    required String id,
    required Snippet snippet,
  }) = _Youtube;

  factory Youtube.fromJson(Map<String, dynamic> json) =>
      _$YoutubeFromJson(json);
}
