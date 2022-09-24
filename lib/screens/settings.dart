import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/repository/database/transaction_db_functions.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/screens/splash_screen.dart';
import 'package:money_manager/screens/statistics_screen.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:money_manager/widgets/settings_row_widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final Uri url = Uri.parse('mailto:shamnadchemmu702@gmail.com');
final Uri fbUrl =
    Uri.parse('https://www.facebook.com/profile.php?id=100005084624697');
final Uri linkedinUrl =
    Uri.parse('https://www.linkedin.com/in/shamnad-chemmu-956486225/');
final Uri instaUrl = Uri.parse('https://www.instagram.com/shamnad_chemmu702/');
final Uri gitUrl = Uri.parse('https://github.com/Shamnad-KK');

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TabController tabController =
        TabController(length: 2, vsync: Scaffold.of(context));
    return Scaffold(
      appBar: const AppBarWidget(
        leading: 'Settings',
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: 50.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SettingsRowWidget(
                          icon: Icons.bar_chart,
                          text: 'Stats',
                          ontap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const StatisticsScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsRowWidget(
                          icon: Icons.help_outline,
                          text: 'Help',
                          ontap: () {
                            _help();
                          },
                        ),
                        SettingsRowWidget(
                          icon: Icons.restore,
                          text: 'Factory reset',
                          ontap: () {
                            _showPopUp(context);
                          },
                        ),
                        SettingsRowWidget(
                          icon: Icons.info_outline,
                          text: 'About',
                          ontap: () {
                            _aboutDialogue(context, tabController);
                          },
                        ),
                        SettingsRowWidget(
                          icon: Icons.share,
                          text: 'Invite a friend',
                          ontap: () {
                            _share();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  'v.1.0.1',
                  style: appBodyTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _help() async {
    try {
      await launchUrl(url);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _faceBook() async {
    try {
      await launchUrl(fbUrl);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _linkedin() async {
    try {
      await launchUrl(linkedinUrl);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _insta() async {
    try {
      await launchUrl(instaUrl);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _gitHub() async {
    try {
      await launchUrl(gitUrl);
    } catch (e) {
      log(e.toString());
    }
  }

  void _share() async {
    Share.share(
      'Check out Money Saver for recording your transactions, https://play.google.com/store/apps/details?id=in.shamnad.money_manager',
    );
  }

  void _aboutDialogue(BuildContext context, TabController tabController) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
              child: Container(
                height: 270.h,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                        indicatorColor: mainColor,
                        controller: tabController,
                        tabs: [
                          Tab(
                            child: Text(
                              'Info',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Contact',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.black),
                            ),
                          )
                        ]),
                    Expanded(
                      child: TabBarView(controller: tabController, children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sBoxH10,
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: AssetImage(
                                        'assets/logo/logo-removebg.png'),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'MONEY SAVER',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'v.1.0.1',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              sBoxH10,
                              Text(
                                'This is an app where you can add your daily transactions according to the category which it belongs to.',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              sBoxH10,
                              Row(
                                children: [
                                  Text(
                                    'DEVELOPED BY',
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'SHAMNAD K.K.',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sBoxH10,
                              Text(
                                'CONTACT ME',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              sBoxH30,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await _faceBook();
                                    },
                                    icon:
                                        const Icon(FontAwesomeIcons.facebookF),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await _insta();
                                      },
                                      icon: const Icon(
                                          FontAwesomeIcons.instagram)),
                                  IconButton(
                                      onPressed: () async {
                                        await _linkedin();
                                      },
                                      icon: const Icon(
                                          FontAwesomeIcons.linkedin)),
                                  IconButton(
                                      onPressed: () async {
                                        await _gitHub();
                                      },
                                      icon:
                                          const Icon(FontAwesomeIcons.github)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ));
  }

  void _showPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Do you want to reset the app ?'),
          actions: [
            TextButton(
              onPressed: () {
                AuthController.resetApp();
                TransactionDbFunctions().deleteAllData();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Reseted successfully'),
                  backgroundColor: Colors.green,
                ));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const SplashScreen(),
                    ),
                    (route) => false);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
