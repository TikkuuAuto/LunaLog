import 'package:flutter/material.dart';

import 'app/luna_log_app.dart';
import 'shared/storage/luna_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final LunaStorage storage = await LunaStorage.open();
  runApp(
    LunaLogApp(
      storage: storage,
      initialEntries: storage.loadEntries(),
      initialSettings: storage.loadSettings(),
    ),
  );
}
