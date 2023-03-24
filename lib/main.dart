import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_pet/providers/user_provider.dart';
import 'package:social_pet/reponsive/mobile_screen.dart';
import 'package:social_pet/reponsive/reponsive_screen.dart';
import 'package:social_pet/reponsive/web_screen.dart';
import 'package:social_pet/screen/login_screen.dart';
import 'package:social_pet/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyDK501dHk_kRoLdR9jcfOzwv5FZpjAU4Ek',
          appId: '1:762207615570:web:ca42dd174088a11d3bfd8b',
          messagingSenderId: "762207615570",
          projectId: "socialpet-f6999",
          storageBucket: "socialpet-f6999.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'SocialPet',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ReponsiveLayout(
                    mobileScreenLayout: MobileScreen(),
                    webScreenLayout: WebScreen());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
                
            }
          return const LoginScreen();
          },
        ),
      ),
    );
  }
}
