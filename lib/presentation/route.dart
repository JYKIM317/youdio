import 'package:go_router/go_router.dart';
import 'package:youdio/presentation/mainPage/main_page.dart';
import 'package:youdio/presentation/search/searchResult/searchResult_page.dart';
import 'package:youdio/presentation/music/music_page.dart';

class YoudioRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MainPage()),
      GoRoute(
          path: '/searchResult',
          builder: (context, state) => const SearchResultPage()),
      GoRoute(path: '/music', builder: (context, state) => MusicPage()),
    ],
  );
}
