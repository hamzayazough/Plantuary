import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_client/models/environment.dart';
import 'package:mobile_client/pages/form.dart';
import 'package:mobile_client/pages/home.dart';

void main() async {
  await dotenv.load(fileName: Environment.fileName);
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Plantuary",
      initialRoute: "/home",
      debugShowCheckedModeBanner: false,
      routes: {
        "/home": (context) => HomePage(),
        "/search-map": (context) => SearchMapPage(),
        "/results": (context) => SearchMapPage(),
      },
    );
  }
}
