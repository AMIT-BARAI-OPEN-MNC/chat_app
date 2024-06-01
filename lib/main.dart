import 'package:chat_app/core/services/DB_helper/database_helper.dart';
import 'package:chat_app/core/theme/theme_manager.dart';
import 'package:chat_app/core/utils/user_Controller/user_provider.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/features/auth/presentation/views/login.dart';
import 'package:chat_app/features/chat/presentation/view_models/chat_message_provider.dart';
import 'package:chat_app/features/chat/presentation/view_models/chatcontroller.dart';
import 'package:chat_app/features/chat/presentation/views/chat_home.dart';
import 'package:chat_app/features/settings/copy_file_Str/test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  await setUpFirebase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeManager _themeManager = ThemeManager();
    return AnimatedBuilder(
      animation: _themeManager,
      builder: (context, _) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Counter()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => ChatMessageProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat app by Amit',
            themeMode: _themeManager.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            initialRoute: '/t',
            routes: {
              '/': (context) => chat_home(),
              '/login': (context) => LoginPage(),
              '/t': (context) => ChatHomePage(),
            },
            // for navigation use this - ** Navigator.pushNamed(context, '/second'); **
          ),
        );
      },
    );
  }
}
