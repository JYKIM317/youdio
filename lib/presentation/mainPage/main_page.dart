import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youdio/provider/mainpage_provider.dart';
import 'package:youdio/presentation/mainPage/main_page_widget.dart';

//Screens
import 'package:youdio/presentation/playlist/playlist_screen.dart';
import 'package:youdio/presentation/search/search_screen.dart';
import 'package:youdio/presentation/shelves/shelves_screen.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentIndex = ref.watch(indexProvider);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          ['플레이리스트', '검색', '서랍'][currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: [
                const PlaylistScreen(),
                const SearchScreen(),
                const ShelvesScreen(),
              ][currentIndex],
            ),
          ),
          const CurrentMusicStateWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.layerGroup),
            label: 'playlist',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidFolder),
            label: 'shelves',
          ),
        ],
        currentIndex: currentIndex,
        onTap: ref.read(indexProvider.notifier).selectIndex,
        backgroundColor: Colors.grey[900],
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.amber,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
