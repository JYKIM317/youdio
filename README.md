# Youdio

유튜브 동영상을 멜론처럼 재생할 수 있도록 개발한 앱입니다.

개발 계기는 유튜브를 이용하는 저의 주 목적이 외부에서 음악감상뿐인데 프리미엄 서비스를 이용하기에 아쉽다는 생각을 해
직접 개발해서 사용하자라는 취지로 사심이 가득하게 개발을 시작하게 되었습니다.

Riverpod을 이용해 MVVM 패턴 구현에 집중했고,
Youtube Data API를 이용해 원하는 유튜브 영상을 검색, 찾기 기능과
음원앱처럼 플레이리스트에 담고, 서랍에 원하는 플레이리스트를 따로 저장해 이용할 수 있는 기능을 제공합니다.

제작 과정에서 Youtube를 어떻게 백그라운드에서, 연속적으로 재생할 수 있을까에 대한 시행착오들이 있었고,
결과적으로 해당 프로젝트에선 오디오만 필요했기 때문에 담아두었던 플레이리스트를 재생했을 때 음원을 추출해 오디오만 재생하는 방식으로 구현했습니다.

- 사용 라이브러리 -

  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  go_router: ^14.1.2
  dio: ^5.4.3+1
  shared_preferences: ^2.2.3
  flutter_riverpod: ^2.5.1
  font_awesome_flutter: ^10.7.0
  cached_network_image: ^3.3.1
  palette_generator: ^0.3.3+3
  just_audio: ^0.9.38
  youtube_explode_dart: ^2.2.1
