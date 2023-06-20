import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import '../common/app_config.dart';
import '../common/assets.dart';
import '../common/colors.dart';
import '../common/hive_boxes.dart';
import '../screens/add_blood_request_screen.dart';
import '../screens/add_news_item.dart';
import '../screens/login_screen.dart';
import '../screens/news_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/who_can_donate_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _showAdmin = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'Blood Donation'),
              accountEmail: Text(user?.email ?? AppConfig.email),
              otherAccountsPictures: [
                if (Hive.box(ConfigBox.key)
                    .get(ConfigBox.isAdmin, defaultValue: false) as bool)
                  InkWell(
                    onTap: () {
                      setState(() => _showAdmin = !_showAdmin);
                    },
                    child: const Tooltip(
                      message: 'Admin Screens',
                      child: CircleAvatar(child: FaIcon(FontAwesomeIcons.userSecret), ),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      headerAnimationLoop: false,
                      dialogType: DialogType.WARNING,
                      title: 'Logout',
                      desc: 'Are you sure you want to logout?',
                      btnCancelText: 'NO',
                      btnCancelOnPress: () {},
                      btnOkText: 'YES',
                      btnOkOnPress: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.route,
                          (route) => false,
                        );
                      },
                    ).show();
                  },
                  child: const Tooltip(
                    message: 'Logout',
                    child: CircleAvatar(child: FaIcon(FontAwesomeIcons.unlock), ),
                  ),
                ),
              ],
              currentAccountPicture: Hero(
                tag: 'profilePicHero',
                child: Container(
                  decoration: const BoxDecoration(
                    color: MainColors.accent,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: user?.photoURL != null
                      ? CachedNetworkImage(
                          imageUrl: user!.photoURL.toString(),
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white70,
                              ),
                            ),
                          ),
                        )
                      : SvgPicture.asset(IconAssets.donor),
                ),
              ),
              margin: EdgeInsets.zero,
            ),
            Expanded(child: Column(children: _screens)),
          ],
        ),
      ),
    );
  }

  List<Widget> get _screens => [
       _DrawerTile(
          title: 'Profile',
          icon: Icons.person,
          destination: ProfileScreen.route,
        ),
       _DrawerTile(
          title: 'Request Blood',
          icon: Icons.bloodtype,
          destination: AddBloodRequestScreen.route,
        ),
        if (_showAdmin)
           _DrawerTile(
            title: 'Add News',
            icon: Icons.add,
            destination: AddNewsItem.route,
          ),
         /*
         _DrawerTile(
          title: 'News and Tips',
          icon: FontAwesomeIcons.bell,
          destination: NewsScreen.route,
        ),
          */
         _DrawerTile(
          title: 'Can I donate blood?',
          icon: FontAwesomeIcons.circleQuestion,
          destination: WhoCanDonateScreen.route,
        ),
      ];
}

class _DrawerTile extends StatelessWidget {
  final String title, destination;
  final IconData icon;

  const _DrawerTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(destination);
      },
    );
  }
}
