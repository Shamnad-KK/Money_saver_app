import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/database/models/category_model/category_model.dart';
import 'package:money_manager/database/models/category_model/category_type_model/category_type_model.dart';
import 'package:money_manager/database/models/reminder_model/reminder_model.dart';
import 'package:money_manager/database/models/transaction_model/transaction_model.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/screens/splash_screen.dart';
import 'package:money_manager/widgets/scroll_behaviour.dart';

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
  if (!Hive.isAdapterRegistered(ReminderModelAdapter().typeId)) {
    Hive.registerAdapter(ReminderModelAdapter());
  }

  runApp(
    const MyApp(),
  );
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
          return MaterialApp(
            builder: (context, Widget? child) {
              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: child!,
              );
            },
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Poppins',
              scaffoldBackgroundColor: bgColor,
            ),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        });
  }
}
