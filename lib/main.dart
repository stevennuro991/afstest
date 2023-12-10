import 'package:afs_test/apps/modules/home/home_screen.dart';
import 'package:afs_test/apps/modules/splash_screen.dart';
import 'package:afs_test/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load();
  SharedPreferences pref = await SharedPreferences.getInstance();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('afsTest');
  bool hasToken =
      pref.getString(LocalStorageKeys.accessToken) != null ? true : false;
  runApp( MyApp(token: hasToken,));
}

class MyApp extends StatelessWidget {
  final bool token;
  const MyApp({super.key, this.token = false});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          navigatorKey: navigatorKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: token ? const HomeScreen() : const SplashScreen()),
    );
  }
}
