import 'package:freezed_annotation/freezed_annotation.dart';

part 'snippet.freezed.dart';
part 'snippet.g.dart';

@freezed
class Snippet with _$Snippet {
  const factory Snippet({
    required String title,
    required String channelTitle,
    required Map<String, dynamic> thumbnails,
  }) = _Snippet;

  factory Snippet.fromJson(Map<String, dynamic> json) =>
      _$SnippetFromJson(json);
}
