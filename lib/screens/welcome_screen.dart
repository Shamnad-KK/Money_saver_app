import 'package:flutter/material.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/models/welcome_screen/welcome_screen_model.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/screens/credentials_screen.dart';
import 'package:money_manager/widgets/small_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  final List<WelcomeModel> welcomeModel = [
    WelcomeModel(
      firstLetter: 'E',
      text: 'very time you\nborrow money,\nyou\'re robbing\nyour future self.',
      image: 'assets/welcome_screen/2.gif',
      author: '- Nathan W. Morris',
    ),
    WelcomeModel(
      firstLetter: 'B',
      text: 'alancing\nyour money is\nthe key to having\nenough.',
      image: 'assets/welcome_screen/5.gif',
      author: '- Elizabeth Warren',
    ),
    WelcomeModel(
      firstLetter: 'M',
      text: 'anage your\nbudget like a pro',
      image: 'assets/welcome_screen/1.gif',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          itemCount: welcomeModel.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: welcomeModel[index].firstLetter,
                              style: largeLetterText,
                              children: [
                                TextSpan(
                                  text: welcomeModel[index].text?.toUpperCase(),
                                  style: largeText30,
                                )
                              ],
                            ),
                          ),
                          Column(
                              children: List.generate(
                            3,
                            (int containerIndex) => Container(
                              margin: EdgeInsets.only(
                                bottom: 10.h,
                              ),
                              height: index == containerIndex ? 28.h : 10.h,
                              width: 8.w,
                              decoration: BoxDecoration(
                                color: index == containerIndex
                                    ? mainColor
                                    : mainColor.withOpacity(0.5.h),
                                borderRadius: BorderRadius.circular(
                                  10.r,
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                      sBoxH10,
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          welcomeModel[index].author?.toUpperCase() ?? '',
                          style: authorText,
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 300.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          welcomeModel[index].image!,
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  index == 2
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Let\'s get started'.toUpperCase(),
                                style: largeText30,
                              ),
                              sBoxH10,
                              SmallButton(
                                ontap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => CredentialScreen(),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
