import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/controllers/settings_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/constants.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = SettingsController();
    return Dialog(
      child: Container(
        height: 270.h,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(indicatorColor: mainColor, controller: tabController, tabs: [
              Tab(
                child: Text(
                  'Info',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  'Contact',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
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
                            backgroundImage:
                                AssetImage('assets/logo/logo-removebg.png'),
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
                                fontSize: 15.sp, fontWeight: FontWeight.bold),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await settingsController.facebook();
                            },
                            icon: const Icon(FontAwesomeIcons.facebookF),
                          ),
                          IconButton(
                              onPressed: () async {
                                await settingsController.insta();
                              },
                              icon: const Icon(FontAwesomeIcons.instagram)),
                          IconButton(
                              onPressed: () async {
                                await settingsController.linkedin();
                              },
                              icon: const Icon(FontAwesomeIcons.linkedin)),
                          IconButton(
                              onPressed: () async {
                                await settingsController.gitHub();
                              },
                              icon: const Icon(FontAwesomeIcons.github)),
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
    );
  }
}
