import 'package:blood_donation/common/hive_boxes.dart';
import 'screens/add_blood_request_screen.dart';
import 'package:blood_donation/screens/add_news_item.dart';
import 'package:blood_donation/screens/edit_profile_screen.dart';
import 'package:blood_donation/screens/home_screen.dart';
import 'package:blood_donation/screens/login_screen.dart';
import 'package:blood_donation/screens/news_screen.dart';
import 'package:blood_donation/screens/profile_screen.dart';
import 'package:blood_donation/screens/registration_screen.dart';
import 'package:blood_donation/screens/splash_screen.dart';
import 'package:blood_donation/screens/tutorial_screen.dart';
import 'package:blood_donation/screens/who_can_donate_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'common/colors.dart';
import 'common/styles.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/blood_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name : "name",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox(ConfigBox.key);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donation',
      theme: ThemeData(
        primarySwatch: MainColors.swatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Fonts.text,
      ),
      initialRoute: SplashScreen.route,
      routes:
      {
        HomeScreen.route: (_) =>  const HomeScreen(),
        TutorialScreen.route: (_) => const TutorialScreen(),
        LoginScreen.route: (_) => const LoginScreen(),
        RegistrationScreen.route: (_) =>  const RegistrationScreen(),
        SplashScreen.route: (_) =>  const SplashScreen(),
        ProfileScreen.route: (_) => const ProfileScreen(),
        WhoCanDonateScreen.route: (_) => const WhoCanDonateScreen(),
        AddBloodRequestScreen.route: (_) => const AddBloodRequestScreen(),
        NewsScreen.route: (_) =>   const NewsScreen(),
        AddNewsItem.route: (_) => const AddNewsItem(),
        EditProfileScreen.route: (_) =>  const EditProfileScreen(),
      },
    );
  }
}
