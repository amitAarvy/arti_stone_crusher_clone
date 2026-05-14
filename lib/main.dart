import 'package:arti_stone_crusher/bloc/login_bloc/login_bloc.dart';
import 'package:arti_stone_crusher/data/repo/challan_repo.dart';
import 'package:arti_stone_crusher/ui/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/challan_bloc/challan_bloc.dart';
import 'data/repo/login_repo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) =>
       MultiBlocProvider(
         providers: [
           BlocProvider(create: (context) => LoginBloc(loginRepo: LoginRepo(), )),
           BlocProvider(create: (context) => ChallanBloc(repo: ChallanRepo(), )),

         ],
         child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Abhay Stone Crusher',
           builder: (context,widget){
             return ScrollConfiguration(
               behavior: const ScrollBehavior().copyWith(
                 physics: const BouncingScrollPhysics(),
               ),
               child: widget!,
             );
           },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Splash(),
               ),
       ),
    );
  }
}