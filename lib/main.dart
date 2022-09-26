import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/controllers/dropdown_controller.dart';
import 'package:money_manager/controllers/search_controller.dart';
import 'package:money_manager/controllers/statistics_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/splash_screen.dart';
import 'package:money_manager/widgets/scroll_behaviour.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryModalAdapter().typeId)) {
    Hive.registerAdapter(CategoryModalAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModalAdapter().typeId)) {
    Hive.registerAdapter(TransactionModalAdapter());
  }

  runApp(
    const MyApp(),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (ctx) => AuthController()),
              ChangeNotifierProvider(create: (ctx) => DropDownController()),
              ChangeNotifierProvider(create: (ctx) => TransactionController()),
              ChangeNotifierProvider(create: (ctx) => CategoryDBController()),
              ChangeNotifierProvider(create: (ctx) => SearchController()),
              ChangeNotifierProvider(create: (ctx) => StatisticsController()),
            ],
            child: MaterialApp(
              builder: (context, Widget? child) {
                return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: child!,
                );
              },
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme:
                    GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                scaffoldBackgroundColor: bgColor,
              ),
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
            ),
          );
        });
  }
}
