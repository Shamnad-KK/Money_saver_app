import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/controllers/settings_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/view/statistics_screen/statistics_screen.dart';
import 'package:money_manager/view/settings_screen/widgets/settings_row_widget.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = SettingsController();
    final authController = Provider.of<AuthController>(context, listen: false);
    final transactionController =
        Provider.of<TransactionController>(context, listen: false);
    settingsController.tabController =
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
                          ontap: () async {
                            await settingsController.help();
                          },
                        ),
                        SettingsRowWidget(
                          icon: Icons.restore,
                          text: 'Factory reset',
                          ontap: () async {
                            settingsController.showPopUP(
                                context, authController, transactionController);
                          },
                        ),
                        SettingsRowWidget(
                          icon: Icons.info_outline,
                          text: 'About',
                          ontap: () {
                            settingsController.aboutDialogue(
                                context, settingsController.tabController);
                          },
                        ),
                        SettingsRowWidget(
                          icon: Icons.share,
                          text: 'Invite a friend',
                          ontap: () async {
                            await settingsController.share();
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
}
