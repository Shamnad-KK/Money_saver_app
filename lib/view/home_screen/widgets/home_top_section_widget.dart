import 'package:flutter/material.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/enums.dart';
import 'package:money_manager/view/add_transaction_screen/add_transaction_screen.dart';
import 'package:money_manager/screens/search_screen.dart';
import 'package:money_manager/view/home_screen/widgets/amount_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTopSectionWidget extends StatelessWidget {
  const HomeTopSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: mainColor,
      expandedHeight: 390.h,
      pinned: true,
      floating: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const SearchScreen(),
            ),
          );
        },
        child: Icon(
          Icons.search,
          size: 35.sp,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddTransactionScreen(
                  type: ScreenAction.addScreen,
                ),
              ),
            );
          },
          icon: Icon(
            Icons.add,
            size: 35.sp,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        title: Consumer<AuthController>(
          builder: (BuildContext context, value, Widget? child) {
            return Text(
              value.name!.toUpperCase(),
            );
          },
        ),
        background: Container(
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AmountCardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
