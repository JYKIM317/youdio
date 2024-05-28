import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youdio/presentation/shelves/shelves_viewmodel.dart';

final shelvesProvider = ChangeNotifierProvider<ShelvesViewModel>((ref) {
  return ShelvesViewModel();
});
