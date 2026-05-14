import 'package:arti_stone_crusher/utils/Images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/splash_services.dart';
import '../auth/login.dart';
import '../home/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SplashServices().isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const Login()),
    //   );
    // });

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFFE4CD), Color(0xffFF8F33)], // gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset(Images.logo,height: 0.25.sh,),
        ),
        // child: Column(
        //
        //   children: const [
        //     Icon(Icons.local_shipping, size: 100, color: Colors.blue),
        //     SizedBox(height: 16),
        //     Text("Challan Management",
        //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
        //   ],
        // ),
      ),
    );
  }
}
