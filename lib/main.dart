import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:itee_exam_app/UI/Bloc/combine_page_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rename_app/rename_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/Bloc/auth_cubit.dart';
import 'UI/Bloc/email_cubit.dart';
import 'UI/Bloc/first_page_cubit.dart';
import 'UI/Bloc/second_page_cubit.dart';
import 'UI/Bloc/third_page_cubit.dart';
import 'UI/Pages/Splashscreen UI/splashscreenUI.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkAndClearCache();
  runApp(const MyApp());
}

/// Checks the app version and clears the cache if the app has been updated.
Future<void> checkAndClearCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;
  String? storedVersion = prefs.getString('app_version');

  if (storedVersion == null || storedVersion != currentVersion) {
    await DefaultCacheManager().emptyCache();
    await prefs.setString('app_version', currentVersion);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(
          0, 162, 222, 1), // Change the status bar color here
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => EmailCubit()),
        BlocProvider(create: (context) => FirstPageCubit()),
        BlocProvider(create: (context) => SecondPageCubit()),
        BlocProvider(create: (context) => ThirdPageCubit()),
        BlocProvider(
          create: (context) {
            // Get instances of the required Cubits
            final firstPageCubit = context.read<FirstPageCubit>();
            final secondPageCubit = context.read<SecondPageCubit>();
            final thirdPageCubit = context.read<ThirdPageCubit>();

            // Pass the instances to CombinedDataCubit
            return CombinedDataCubit(
              firstPageCubit: firstPageCubit,
              secondPageCubit: secondPageCubit,
              thirdPageCubit: thirdPageCubit,
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ITEE Exam Registration App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromRGBO(0, 162, 222, 1)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

