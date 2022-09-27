import 'package:flutter/material.dart';
import 'package:money_manager/controllers/dropdown_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/view/home_screen/widgets/all_transaction_list_widget.dart';
import 'package:money_manager/view/home_screen/widgets/custom_transctn_list.dart';
import 'package:money_manager/view/home_screen/widgets/today_trasaction_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBottomSectionWidget extends StatelessWidget {
  const HomeBottomSectionWidget({
    Key? key,
    required this.tabController,
    required this.dropDownController,
  }) : super(key: key);

  final TabController tabController;
  final DropDownController dropDownController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        20.h,
        20.w,
        20.h,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 20.w,
              top: 10.h,
              right: 20.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TRANSACTIONS',
                      style: appLargeTextStyle,
                    ),
                    Consumer<DropDownController>(
                      builder: (BuildContext context, value, Widget? child) {
                        return value.homeDrop(tabController);
                      },
                    ),
                  ],
                ),
                sBoxH10,
              ],
            ),
          ),
          TabBar(
            onTap: (value) {
              tabController.index == 2
                  ? dropDownController.customFilter(
                      tabController: tabController)
                  : dropDownController.allFilter(tabController: tabController);
            },
            indicatorColor: mainColor,
            controller: tabController,
            tabs: [
              Tab(
                child: Text(
                  'ALL',
                  style: appBodyTextStyle,
                ),
              ),
              Tab(
                child: Text(
                  'TODAY',
                  style: appBodyTextStyle,
                ),
              ),
              Tab(
                child: Text(
                  'CUSTOM',
                  style: appBodyTextStyle,
                ),
              ),
            ],
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              AllTransactionList(
                tabController: tabController,
              ),
              TodayTransactionList(
                tabController: tabController,
              ),
              CustomTransactionList(
                tabController: tabController,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
