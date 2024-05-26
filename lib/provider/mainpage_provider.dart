import 'package:flutter_riverpod/flutter_riverpod.dart';

final indexProvider = StateNotifierProvider<MainPageIndexNotifier, int>((ref) {
  return MainPageIndexNotifier();
});

class MainPageIndexNotifier extends StateNotifier<int> {
  MainPageIndexNotifier() : super(0);

  selectIndex(int index) {
    state = index;
  }
}
